module Formular
  class Builder
    # A Collection represents the widget for <checkbox and <radio groups, and <select.
    class Collection < Control
      def render(attributes, options={}, html="", &block)
        collection(attributes, options, html, &block)
      end

      def collection(attributes, options={}, html="", &block)
        options[:collection].each_with_index do |model, i|
          html << item(model, i, attributes, options, &block)
        end

        html
      end

    private
      def item(model, i, attributes, options, &block)
        yield(model: model, index: i)
      end

      # We check for #to_s equality on every item in `:checked`.
      def checked?(value, checked:, **)
        checked.map(&:to_s).include?(value.to_s)
      end

      class Checkbox < Collection
        include Id

        # Invoked per item.
        def item(model, i, attributes, options, &block)
          item_options = {
            value: value = model.last,
            label: model.first,
            append_brackets: true,
            checked: checked?(value, options),
            skip_hidden: i < options[:collection].size-1,
            id: id_for(options[:name], options.merge(suffix: [value])),
            skip_suffix: true,
            inline: options[:inline],
          }

          # item_options.merge!(options[:item_options]) if options[:item_options] # DISCUSS: hmpf, well... if, then allow that generically.

          yield(model: model, options: item_options, index: i) # usually checkbox(options) or something.
        end
      end

      class Radio < Collection
        include Id

        # Invoked per item.
        def item(model, i, attributes, options, &block)
          item_options = {
            value: value = model.last,
            label: model.first,
            checked: checked?(value, options),
            id: id_for(options[:name], options.merge(suffix: [value])),
            skip_suffix: true,
            inline: options[:inline],
          }

          yield(model: model, options: item_options, index: i) # usually checkbox(options) or something.
        end
      end
    end

    class Select < Collection
      # def render(attributes, options, &block)
      #   @tag.(:select, attributes: attributes, content: super)
      # end

      def option(content, attributes)
        checked!(attributes, {}, :selected)
        @tag.(:option, attributes, content)
      end

      def collection(attributes, options, html="", &block)
        @tag.(:select, attributes, super)
      end

    private
      include Checked

      def item(item, i, attributes, options, &block)
        item_options = {
          value:    value = item.last,
          label:    item.first,
          selected: checked?(value, options),
        }

        yield(select: self, model: item, index: i, options: item_options)
      end
    end
  end
end
