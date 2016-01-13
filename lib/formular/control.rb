module Formular
  class Builder # i hate that, please, give use namespace Builder
    class Input
      def initialize(element)
        @element = element
      end

      def call(attributes, options, tag=:input)
        @element.tag(tag, attributes: attributes, content: options[:content]) # DISCUSS: save hash lookup for :content?
      end

      def error(attributes, options, tag=:input)
        call(attributes, options, tag)
      end
    end

    class Textarea < Input
      def call(attributes, options, tag=:textarea)
        attributes= attributes.dup # FIXME.

        content = attributes.delete(:value) || ""

        @element.tag(:textarea, attributes: attributes, content: content) # DISCUSS: save hash lookup for :content?
      end
    end

    class Checkbox < Input
      def call(attributes, options, *)
        attributes= attributes.dup # FIXME.

        attributes[:checked] = :checked if attributes[:value].to_s == toggles[:on].to_s
        attributes[:value]   = toggles[:on]

        @element.tag(:input, attributes: { type: :hidden, value: toggles[:off], name: attributes[:name] }) + super
      end

    private
      def toggles
        { on: 1, off: 0}
      end
    end
  end
end
