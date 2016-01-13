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

    def initialize(element: Element.new, path: [], prefix: ["form"], model:, parent:nil)
      @element = element
      @path    = path # e.g. [replies, author]
      @model   = model
      @errors  = model.errors||{} # TODO: allow other ways to inject errors object.
      @prefix  = prefix

      @controls = {
        input:    self.class::Input.new(@element), # TODO: make this more explicit with container.
        textarea: self.class::Textarea.new(@element), # TODO: make this more explicit with container.
        checkbox: self.class::Checkbox.new(@element), # TODO: make this more explicit with container.
      }
    end

    def form(**attributes, &block)
      content = capture(self, &block)

      @element.form(attributes: attributes, content: content)
    end

    def input(name, attributes={})
      control(:input, name, attributes)
    end

    # normalize generic options.
    private def control(tag, name, attributes, options={}) # TODO: rename tag to control_name
      options = options.merge(
        path:  path = @path + [name],
        model: @model,
        error: error = @errors[name],
      )

      attributes = { name: form_encoded_name(path), type: :text,
        value: @model.send(name),
         }.merge(attributes)

      # optional
      id!(name, attributes)
      options[:label] = attributes.delete(:label) # TODO: yepp, prototyping.
      # label! would compile the label string.

      # TODO: test me: name from attributes has precedence. attributes is immutual. test :type overwrite

      # render control.
      return @controls[tag].error(attributes, options) if error && error.any?
      @controls[tag].(attributes, options)
    end

    def textarea(name, attributes={})
      control(:textarea, name, attributes)
    end

    def button(attributes={})
      # TODO: use control!
      @element.tag(:input, attributes: { type: :button }.merge(attributes))
      # input({ type: :button }.merge(attributes))
    end

    def checkbox(name, attributes={})
      control(:checkbox, name, { type: :checkbox }.merge(attributes))
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

    def fieldset(&block) # TODO: merge with #form!
      content = capture(self, &block)
      return if content == "" # DISCUSS: should that be here?

      @element.fieldset(content: content)
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
  end
end
