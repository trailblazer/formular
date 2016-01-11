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
    end

    def form(**attributes, &block)
      content = capture(self, &block)

      @element.form(attributes: attributes, content: content)
    end

    def input(options={})
      options[:name] = (@path + [options[:name]]).join(".")

      @element.input(options)
    end

    def button(options={})
      input({ type: :button }.merge(options))
    end

    def nested(name, &block)
      nested = @model.send(name)
      # TODO: implement for collection, too. (magic or explicit collection: true?)
      # TODO: handle nil/[]
      # TODO: n-level nesting: path with local_path+
      self.class.new(model: nested, path: [name], parent: self).fieldset(&block)
    end

    def fieldset(&block)
      content = @model.collect do |model|
        capture(self, &block) # FIXME: this should be a separate instance for every call? so we can use it for dynamic forms?
      end.join("")

      @element.fieldset(content: content)
    end
  end
end
