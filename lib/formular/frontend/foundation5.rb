module Formular
  # http://foundation.zurb.com/sites/docs/v/5.5.3/components/forms.html

  # TODO: switches, prefix actions
  module Foundation5
    # <label class="error">Error
    #   <input type="text" class="error" />
    # </label>
    # <small class="error">Invalid entry</small>
    class Builder < Formular::Builder
      module ErrorWrap
        def error(attributes, options)
          shared = { class: [:error] }

          input = super(shared.merge(attributes), options )

          input +
          # @element.tag(:label, attributes: shared, content: input) +
            @tag.(:small, attributes: shared, content: options[:error])
        end
      end

      # <label>Input Label
      #   <input type="text" placeholder="large-4.columns" />
      # </label>
      class Input < Formular::Builder::Input
        include ErrorWrap

        def call(attributes, options)
          return super unless options[:label]
          @tag.(:label, attributes: {}, content: "#{options[:label]}#{super}")
        end
      end

      class Textarea < Formular::Builder::Textarea
        include ErrorWrap
      end

      # <input id="checkbox1" type="checkbox"><label for="checkbox1">Checkbox 1</label>
      class Checkbox < Formular::Builder::Checkbox
      end

      class Collection
      # <label>Check these out</label>
      # <input id="checkbox1" type="checkbox"><label for="checkbox1">Checkbox 1</label>
      # <input id="checkbox2" type="checkbox"><label for="checkbox2">Checkbox 2</label>
        class Checkbox < Formular::Builder::Collection::Checkbox
          def call(attributes={}, options={}, html="", &block)
            @tag.(:label, attributes: {}, content: options[:label]) +  # TODO: allow attributes.
              super
          end

          include ErrorWrap
        end

        class Radio < Checkbox
        end
      end
    end
    # TODO: TEST that attributes hash is immutuable.
  end
end
