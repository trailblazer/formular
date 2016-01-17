# Controls treat attributes as mutuable.
module Formular
  class Builder # i hate that, please, give use namespace Builder
    module Label # i choose not to make this a separate class on purpose.
      # DISCUSS: pass in content?
      def label(attributes, options) # DISCUSS: should labels be part of a Control or a higher-level widget?
        return "" unless options[:label]
        @tag.(:label, attributes: { for: attributes[:id] }, content: "#{options[:label]}")
      end
    end

    module Checked
      def checked!(attributes, options, option_name=:checked)
        if attributes.has_key?(option_name)
          attributes.delete(option_name) if !attributes[option_name]
          return
        end

        attributes[option_name] = :checked if attributes[:value].to_s == options[:reader_value].to_s
      end
    end

    class Input
      def initialize(tag)
        @tag = tag
      end

      def call(attributes, options, tag=:input)
        attributes[:value] ||= options[:reader_value]

        @tag.(tag, attributes: attributes, content: options[:content]) # DISCUSS: save hash lookup for :content?
      end

      def error(attributes, options, tag=:input)
        call(attributes, options, tag)
      end
    end

    class Textarea < Input
      def call(attributes, options, tag=:textarea)
        attributes[:value] ||= options[:reader_value] # FIXME.

        content = attributes.delete(:value) || ""

        @tag.(:textarea, attributes: attributes, content: content) # DISCUSS: save hash lookup for :content?
      end
    end

    # value = rendered value
    # options[:reader_value]
    # Stand-alone checkbox a la "Accept our terms: []".
    class Checkbox < Input
      def call(attributes, options, *)
        options[:unchecked_value] ||= default_values[:unchecked]

        attributes[:value] ||= default_values[:value]

        # FIXME: Merge with Radio.
        attributes[:id] += "_#{attributes[:value]}"
        checked!(attributes, options)

        # DISCUSS: refactor to #render
        html = ""
        html << render_hidden(attributes, options) unless options[:skip_hidden]
        html << super
        html << label(attributes, options)
      end

    private
      include Label
      include Checked

      def default_values
        { value: 1, unchecked: 0}
      end

      # <input type="hidden" value="0" name="public" />
      def render_hidden(attributes, options)
        @tag.(:input, attributes: { type: :hidden, value: options[:unchecked_value], name: attributes[:name] })
      end
    end

    class Radio < Input
      def call(attributes, options, *)
        attributes[:value] ||= options[:reader_value] # FIXME.

        attributes[:id] += "_#{attributes[:value]}"

        checked!(attributes, options)

        html = ""
        html << super
        html << label(attributes, options)
      end

      # TODO: move label to Input.
    private
      include Label
      include Checked
    end

    class Select < Input
      def call(attributes, options, *)
        content = options[:collection].each_with_index.collect do |cfg, i|
          options[:block].call self, cfg
        end.join("")


        html = ""
        html << @tag.(:select, attributes: attributes, content: content)
      end

      # TODO: do we really *need* this DSL method?
      def option(content, attributes)
        checked!(attributes, {}, :selected)
        @tag.(:option, content: content, attributes: attributes)
      end

    private
      include Checked
    end
  end
end

# DISCUSS: use kw args instead of private_options?
