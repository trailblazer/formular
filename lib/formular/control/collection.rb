module Formular
  class Builder
    class Collection < Input
      def call(options={}, bla={}, html="", &block)
        options[:collection].each_with_index { |model, i| html << item(model, i, options, bla, &block) }
        html
      end

      def error(*args, &block)
        call(*args, &block)
      end

    private
      def item(model, i, options, bla, &block)
        yield(model: model, index: i)
      end

      class Checkbox < Collection
        include Id

        # Invoked per item.
        def item(model, i, options, bla, &block)
          item_options = {
            value: value = model.last,
            label: model.first,
            append_brackets: true,
            checked: options[:checked].include?(value),
            skip_hidden: i < options[:collection].size-1,
            id: id_for(bla[:name], bla.merge(suffix: [value])),
            skip_suffix: true,
          }

          yield(model: model, options: item_options, index: i) # usually checkbox(options) or something.
        end
      end
    end
  end
end
