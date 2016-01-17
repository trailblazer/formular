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
      attributes = defaults_for(name, attributes)

      # TODO: move outside. kw args
      (options[:private_options] || []).each { |k| options[k] = attributes.delete(k) if attributes.has_key?(k) }

      options = options.merge(
        path:         path = @path + [name],
        model:        @model,
        error:        error = @errors[name],
        reader_value: reader_value,
        builder:      self,
      )

      attributes = { name: form_encoded_name(path) }.merge(attributes)

      # optional
      id!(name, attributes)
      options[:label] = attributes.delete(:label) # TODO: yepp, prototyping.
      # label! would compile the label string.


      # render control.
      return @controls[tag].error(attributes, options) if error && error.any?
      @controls[tag].(attributes, options)
    end

    def textarea(name, attributes={})
      control(:textarea, name, attributes)
    end

    def button(attributes={})
      # TODO: use control!
      @tag.(:input, attributes: { type: :button }.merge(attributes))
      # input({ type: :button }.merge(attributes))
    end

    def checkbox(name, attributes={})
      control(:checkbox, name, { type: :checkbox }.merge(attributes),
        { private_options: [:checked_value, :unchecked_value, :skip_hidden] })
    end

    def radio(name, attributes={})
      control(:radio, name, { type: :radio }.merge(attributes))
    end

    def nested(name, collection:false, &block)
      nested = @model.send(name)
      # TODO: implement for collection, too. (magic or explicit collection: true?)
      # TODO: handle nil/[]
      # TODO: n-level nesting: path with local_path+ AND INDEX FOR COLLECTIONS.

      # content
      content = nested.each_with_index.collect do |model, i|
        self.class.new(model: model, path: [name], parent: self, prefix: @prefix+[name, i]).(&block)
      end.join("")

      fieldset { content }
    end
    def collection(name, collection, *) # FIXME: merge with nested.
      collection.each_with_index.collect do |cfg, i|
        # label, model = cfg
        # DISCUSS: could we use call here somehow?
        # self.class.new(model: model, path: [name], parent: self, prefix: @prefix+[name, i]).(&block)
        # yield self.class.new(model: model, path: [name], parent: self, prefix: @prefix+[name, i]).(&block), model
        yield self, cfg
      end.join("")
    end

    def fieldset(&block) # TODO: merge with #form!
      content = capture(self, &block)
      return if content == "" # DISCUSS: should that be here?

      @tag.(:fieldset, content: content)
    end

    def select(name, collection, *, &block) # FIXME: merge with nested.
      # FIXME: make kw args in controls!
      control(:select, name, { collection: collection, block: block }, private_options: [:collection, :block, :builder, :builder], builder: self)
    end

  private
    # all private methods here will soon be extracted to Control.
    def id!(name, attributes)
      id = attributes.delete(:id)
      return if id == false
      return attributes[:id] = id unless id.nil?
      attributes[:id] = (@prefix+[name]).join("_")
    end
    # [replies, email] => replies[email]
    def form_encoded_name(path)
      path[0].to_s + path[1..-1].collect { |segment| "[#{segment}]" }.join("")
    end

    # TODO: id! etc. is just another default! step.
    def defaults_for(name, attributes)
      @defaults.merge(attributes)
    end
  end
end
