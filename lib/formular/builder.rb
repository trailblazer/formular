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

    def initialize(tag: Tag.new, path: [], prefix: ["form"], model:, parent:nil, defaults:{})
      @tag      = tag
      @path     = path # e.g. [replies, author]
      @model    = model
      @errors   = model.errors||{} # TODO: allow other ways to inject errors object.
      @prefix   = prefix
      @defaults = defaults

      @controls = {
        input:    self.class::Input.new(@tag),
        textarea: self.class::Textarea.new(@tag),
        checkbox: self.class::Checkbox.new(@tag),
        radio:    self.class::Radio.new(@tag),
        select:   self.class::Select.new(@tag),
        checkbox_collection: self.class::Collection::Checkbox.new(@tag),
        radio_collection: self.class::Collection::Radio.new(@tag),
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
    private def control(tag, name, attributes, options={}) # TODO: rename tag to control_name
      reader_value = @model.send(name)

      # TODO: test me: name from attributes has precedence. attributes is immutual.

      options    = normalize_options!(name, attributes, options, reader_value)
      attributes = normalize_attributes!(name, attributes, options)

      # optional
      id!(name, attributes, prefix: @prefix)

      # render control.
      render_control(tag, attributes, options)
    end

    private def render_control(tag, attributes, options, &block)
      return @controls[tag].error(attributes, options, &block) if options[:error] && options[:error].any?
      @controls[tag].(attributes, options, &block)
    end

    private def normalize_options!(name, attributes, options, reader_value) # FIXME: do reader_value somewhre else
      private_options_for(options).each { |k| options[k] = attributes.delete(k) if attributes.has_key?(k) }

      options.merge(
        path:         @path + [name],
        model:        @model,
        error:        @errors[name],
        reader_value: reader_value,
        builder:      self,
        name:         name,
        prefix:       @prefix,
      )
    end

    private def private_options_for(options)
      return options[:private_options] + [:label] if options[:private_options]
      [:label]
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
        { private_options: [:checked_value, :unchecked_value, :skip_hidden, :append_brackets, :skip_suffix] })
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
    def collection(name, collection, options={}, &block)
      if options[:type] == :checkbox
        return checkbox_collection(name, collection, options, &block)
      end

      if options[:type] == :radio
        return radio_collection(name, collection, options, &block)
      end

      # TODO: do we really need this?
      Collection[*collection].() do |cfg, i|
        yield self, cfg
      end
    end

    # default (no block): invoke `checkbox(name, ..)`.
    def checkbox_collection(name, collection, attributes={}, &block)
      blk = block || ->(options:, **) { checkbox(name, options) }

        # FIXME: merge with #control:
      options = normalize_options!(name, attributes, {
        collection: collection,
        private_options: [:type, :checked]
      }, nil )

      render_control(:checkbox_collection, attributes, options, &blk)
    end

    def radio_collection(name, collection, attributes={}, &block)
      blk = block || ->(options:, **) { radio(name, options) }

        # FIXME: merge with #control:
      options = normalize_options!(name, attributes, {
        collection: collection,
        private_options: [:type, :checked]
      }, nil )

      render_control(:radio_collection, attributes, options, &blk)
    end

    def fieldset(&block) # TODO: merge with #form!
      content = capture(self, &block)
      return if content == "" # DISCUSS: should that be here?

      @tag.(:fieldset, content: content)
    end

    def select(name, collection, attributes={}, &block) # FIXME: merge with nested.
      # FIXME: make kw args in controls!
      control(:select, name, attributes.merge(collection: collection, block: block), private_options: [:collection, :block, :selected], builder: self)
    end

  private
    # all private methods here will soon be extracted to Control.

    # [replies, email] => replies[email]
    def form_encoded_name(path)
      path[0].to_s + path[1..-1].collect { |segment| "[#{segment}]" }.join("")
    end
  end
end
