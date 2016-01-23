module Formular
  # Public API.
  class Builder
    module Capture # TODO: this could be a separate cell or something.
      # Only works with Slim, so far.
      def capture(*args)
        yield(*args)
      end
    end
    include Capture

    def call(&block)
      capture(self, &block)
    end

    module Id
      def id_for(name, prefix:, suffix:[], **)
        (prefix+[name]+suffix).join("_")
      end

      def id!(name, attributes, options)
        id = attributes.delete(:id)
        return if id == false
        return attributes[:id] = id unless id.nil?

        attributes[:id] = id_for(name, options)
      end
    end
    include Id

    def initialize(tag: Tag.new, path: [], prefix: ["form"], model:, parent:nil, errors:nil)
      @tag      = tag
      @path     = path # e.g. [replies, author]
      @model    = model
      @errors   = errors || model.errors||{} # TODO: allow other ways to inject errors object.
      @prefix   = prefix

      @controls = {
        input:    self.class::Input.new(@tag),
        textarea: self.class::Textarea.new(@tag),
        checkbox: self.class::Checkbox.new(@tag),
        radio:    self.class::Radio.new(@tag),
        select:   self.class::Select.new(@tag),
        collection_checkbox: self.class::Collection::Checkbox.new(@tag),
        collection_radio:    self.class::Collection::Radio.new(@tag),
        collection:    self.class::Collection.new(@tag),
      }
    end

    def form(**attributes, &block)
      content = capture(self, &block)

      @tag.(:form, attributes: attributes, content: content)
    end

    def input(name, attributes={})
      control(:input, name, { type: :text }.merge(attributes))
    end

    # normalize generic options.
    # provides
    #  attributes:
    #  options: :id
    private def control(tag, name, attributes, options={}, exclude=[], &block) # TODO: rename tag to control_name
      # TODO: make that extras stuff nicer.
      extras = {}
      extras[:reader_value] = @model.send(name) unless exclude.include?(:reader_value)
      id!(name, attributes, prefix: @prefix) unless exclude.include?(:id)

      # TODO: test me: name from attributes has precedence. attributes is immutual.

      options    = normalize_options!(name, attributes, options.merge(extras))
      attributes = normalize_attributes!(name, attributes, options)

      render_control(tag, attributes, options, &block)
    end

    private def render_control(tag, attributes, options, &block)
      @controls[tag].(attributes, options, options[:error] && options[:error].any?, &block)
    end

    private def normalize_options!(name, attributes, options)
      private_options_for(options).each { |k| options[k] = attributes.delete(k) if attributes.has_key?(k) }

      options.merge(
        path:         @path + [name],
        model:        @model,
        error:        @errors[name],
        builder:      self,
        name:         name,
        prefix:       @prefix,
      ) { |k, v, n| v }
    end

    private def private_options_for(options, default_options = [:label, :error, :inline, :wrapper])
      return options[:private_options] + default_options if options[:private_options]
      default_options
    end

    private def normalize_attributes!(name, attributes, options)
      { name: form_encoded_name(options[:path]) }.merge(attributes)
    end

    def textarea(name, attributes={})
      control(:textarea, name, attributes)
    end

    def button(attributes={})
      # TODO: use control!
      @tag.(:input, attributes: { type: :button }.merge(attributes))
      # input({ type: :button }.merge(attributes))
    end

    def label(content, attributes)
      @tag.(:label, attributes: attributes, content: content )
    end

    def checkbox(name, attributes={})
      # return Collection::Checkbox[*]
      control(:checkbox, name, { type: :checkbox }.merge(attributes),
        { private_options: [:checked_value, :unchecked_value, :skip_hidden, :append_brackets, :skip_suffix] }) # FIXME: controls should be able to add private_options
    end

    def radio(name, attributes={})
      control(:radio, name, { type: :radio }.merge(attributes),
        { private_options: [:skip_suffix] })
    end

    def nested(name, collection:false, &block)
      nested = @model.send(name)
      # TODO: implement for collection, too. (magic or explicit collection: true?)
      # TODO: handle nil/[]
      # TODO: n-level nesting: path with local_path+ AND INDEX FOR COLLECTIONS.

      # content
      content = nested.each_with_index.collect do |model, index|
      # content = Collection[*nested].() do |model:, index:, **|
        self.class.new(model: model, path: [name], parent: self, prefix: @prefix+[name, index]).(&block)
      end.join("")

      fieldset { content }
    end

    def collection(name, collection, type:nil, **attributes, &block)
      default_block = {
        radio:    ->(options:, **) { radio(name, options) },
        checkbox: ->(options:, **) { checkbox(name, options.merge(error: false)) }
      }

      blk  = block || default_block[type]

      control = "collection"
      control << "_#{type}" if type

      control(control.to_sym, name, attributes, {
        collection: collection,
        private_options: [:checked]
      }, [:reader_value], &blk) # FIXME: to_sym sucks.
    end
    # new API for controls: (checked:, special:, config:, **attributes)

    def fieldset(&block) # TODO: merge with #form!
      content = capture(self, &block)
      return if content == "" # DISCUSS: should that be here?

      @tag.(:fieldset, content: content)
    end

    def select(name, collection, attributes={}, &block) # DISCUSS: can we merge that with #collection?
      control(:select, name, attributes.merge(collection: collection), private_options: [:collection, :selected], &block)
    end

  private
    # all private methods here will soon be extracted to Control.

    # [replies, email] => replies[email]
    def form_encoded_name(path)
      path[0].to_s + path[1..-1].collect { |segment| "[#{segment}]" }.join("")
    end
  end
end
