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
        attributes= attributes.dup
        content = attributes.delete(:value) || ""

        @element.tag(:textarea, attributes: attributes, content: content) # DISCUSS: save hash lookup for :content?
      end
    end

    class Checkbox < Input
    end
  end
end
