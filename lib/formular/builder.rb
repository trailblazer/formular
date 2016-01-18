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
      # return Collection::Checkbox[*]
      control(:checkbox, name, { type: :checkbox }.merge(attributes),
        { private_options: [:checked_value, :unchecked_value, :skip_hidden, :append_brackets] })
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
      # content = nested.each_with_index.collect do |model, i|
      content = Collection[*nested].() do |model, i|
        self.class.new(model: model, path: [name], parent: self, prefix: @prefix+[name, i]).(&block)
      end

      fieldset { content }
    end
    def collection(name, collection, options={}) # FIXME: merge with nested.
      if options[:checkbox]
        return checkbox_collection(name, collection, options)
      end

      Collection[*collection].() do |cfg, i|
        yield self, cfg
      end
    end

    def checkbox_collection(name, collection, options={})
      Collection::Checkbox[*collection].(options) { |model, item_options| checkbox(name, item_options) }
    end

    # TODO: checkbox group where every second item has different class?

    class Collection < Array # TODO: Control interface.
      def call(options={}, html="", &block)
        each_with_index { |model, i| html << item(model, i, options, &block) }
        html
      end

    private
      def item(model, i, options, &block)
        yield model, i
      end

      class Checkbox < Collection
        # Invoked per item.
        def item(model, i, options, &block)
          item_options = {
            value: value = model.last,
            label: model.first,
            append_brackets: true,
            checked: options[:checked].include?(value),
            skip_hidden: i == size-1 ? false : true
          }

          yield(model, item_options, i) # usually checkbox(options) or something.
        end
      end
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
