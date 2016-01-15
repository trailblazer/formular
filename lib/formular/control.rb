module Formular
  class Builder # i hate that, please, give use namespace Builder
    module Label # i choose not to make this a separate class on purpose.
      # DISCUSS: pass in content?
      def label(attributes, options) # DISCUSS: should labels be part of a Control or a higher-level widget?
        return "" unless options[:label]
        @element.tag(:label, attributes: { for: attributes[:id] }, content: "#{options[:label]}")
      end
    end

    class Input
      def initialize(element)
        @element = element
      end

      def call(attributes, options, tag=:input)
        attributes[:value] ||= options[:reader_value]

        @element.tag(tag, attributes: attributes, content: options[:content]) # DISCUSS: save hash lookup for :content?
      end

      def error(attributes, options, tag=:input)
        call(attributes, options, tag)
      end
    end

    class Textarea < Input
      def call(attributes, options, tag=:textarea)
        attributes[:value] ||= options[:reader_value] # FIXME.

        content = attributes.delete(:value) || ""

        @element.tag(:textarea, attributes: attributes, content: content) # DISCUSS: save hash lookup for :content?
      end
    end

    # checked_value = rendered_value
    # value => actual state of model property. => model_value/reader_value
    class Checkbox < Input
      def call(attributes, options, *)
        # options = default_values.merge(options)
        options[:unchecked_value] ||= default_values[:unchecked]
puts "@@@@@ #{attributes.inspect}"
        attributes[:value] ||= default_values[:value]


        attributes[:checked] = :checked if attributes[:value].to_s == options[:reader_value].to_s

        # DISCUSS: refactor to #render
        @element.tag(:input, attributes: { type: :hidden, value: options[:unchecked_value], name: attributes[:name] }) +
          super +
          label(attributes, options)
      end

    private
      include Label

      def default_values
        { value: 1, unchecked: 0}
      end
    end

    class Radio < Input
      def call(attributes, options, *)
        attributes[:value] ||= options[:reader_value] # FIXME.

        attributes[:id] += "_#{attributes[:value]}"
        attributes[:checked] = :checked if attributes[:value].to_s == options[:reader_value].to_s

        super +
          label(attributes, options)
      end

      # TODO: move label to Input.
    private
      include Label
    end
  end
end
