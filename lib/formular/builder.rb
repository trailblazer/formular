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

    def initialize(element: Element.new, path: [], model:, parent:nil)
      @element = element
      @path    = path # e.g. [replies, author]
      @model   = model
      @errors  = model.errors||{} # TODO: allow other ways to inject errors object.


      @controls = {
        input:    self.class::Input.new(@element), # TODO: make this more explicit with container.
        textarea: self.class::Textarea.new(@element) # TODO: make this more explicit with container.
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
    private def control(tag, name, attributes, options={})
      options = options.merge(
        path:  path = @path + [name],
        model: @model,
        error: error = @errors[name]
      )

      attributes = { name: form_encoded_name(path), type: :text,
        value: @model.send(name) }.merge(attributes)
      # TODO: test me: name from attributes has precedence. attributes is immutual. test :type overwrite

      # render control.
      return @controls[tag].error(attributes, options, tag) if error && error.any?
      @controls[tag].(attributes, options, tag)
    end

    def textarea(name, attributes={})
      control(:textarea, name, attributes)
    end

    def button(attributes={})
      # TODO: use control!
      @element.tag(:input, attributes: { type: :button }.merge(attributes))
      # input({ type: :button }.merge(attributes))
    end

    def nested(name, collection:false, &block)
      nested = @model.send(name)
      # TODO: implement for collection, too. (magic or explicit collection: true?)
      # TODO: handle nil/[]
      # TODO: n-level nesting: path with local_path+ AND INDEX FOR COLLECTIONS.

      # content
      content = nested.collect do |model|
        self.class.new(model: model, path: [name], parent: self).fieldset(&block) # FIXME: fieldset is wrong, should be #call.
      end.join("")


    end

    def fieldset(&block) # TODO: merge with #form!
      content = capture(self, &block)

      @element.fieldset(content: content)
    end

  private
    # [replies, email] => replies[email]
    def form_encoded_name(path)
      path[0].to_s + path[1..-1].collect { |segment| "[#{segment}]" }.join("")
    end
  end
end
