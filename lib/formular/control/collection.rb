module Formular
  class Builder
    # A Collection represents the widget for <checkbox and <radio groups, and <select.
    class Collection < Input
      def render(attributes, options={}, html="", &block)
        options[:collection].each_with_index do |model, i|
          html << item(model, i, attributes, options, &block)
        end

        html
      end

      # def error(*args, &block)
      #   render(*args, &block)
      # end

    private
      def item(model, i, attributes, options, &block)
        yield(model: model, index: i)
      end

      # We check for #to_s equality on every item in `:checked`.
      def checked?(value, options)
        options[:checked].map(&:to_s).include?(value.to_s)
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
          }

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
          }

          yield(model: model, options: item_options, index: i) # usually checkbox(options) or something.
        end
      end
    end

    class Select < Collection
      def render(attributes, options, &block)
        @tag.(:select, attributes: attributes, content: super)
      end

      def option(content, attributes)
        checked!(attributes, {}, :selected)
        @tag.(:option, content: content, attributes: attributes)
      end

    private
      include Checked

      # def render_option(cfg, i, options)
      def item(item, i, attributes, options, &block)
        block_given? ?
          yield(self, model: item, index: i) :                                        # user leverages DSL.
          option(item.first, value: item.last, selected: options[:selected].include?(item.last)) # automatically create <option>.
      end
    end
  end
end
