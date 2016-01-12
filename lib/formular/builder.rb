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
    end

    def form(**attributes, &block)
      content = capture(self, &block)

      @element.form(attributes: attributes, content: content)
    end

    def input(name, attributes={})
      options = {
        path:  path = @path + [name],
        model: @model,
        error: error = @errors[name]
      }

      attributes = { name: form_encoded_name(path) }.merge(attributes) # TODO: test me: name from attributes has precedence. attributes is immutual.

      return render_input_error(attributes, options) if error && error.any?
      render_input(attributes, options)
    end

    # DISCUSS: use proc/function here that can easily be replaced?
    def render_input(attributes, options)
      @element.tag(:input, attributes: attributes)
    end

    def render_input_error(attributes, options)
      render_input(attributes, options)
    end

    def button(attributes={})
      render_input({ type: :button }.merge(attributes), {})
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

# def input
#   super(options.merge ...) + "bla"
# end

# # meaning 3 items pipeline: change options, run "super", run Input
# Input -> { super.(options.merge ..) + "bla" }
