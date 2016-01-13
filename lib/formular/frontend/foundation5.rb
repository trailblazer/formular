module Formular
  # http://foundation.zurb.com/sites/docs/v/5.5.3/components/forms.html
  module Foundation5
    # <label class="error">Error
    #   <input type="text" class="error" />
    # </label>
    # <small class="error">Invalid entry</small>
    class Builder < Formular::Builder
      module ErrorWrap
        def error(attributes, options, tag)
          shared = { class: [:error] }

          input = super(shared.merge(attributes), options, tag )

          input +
          # @element.tag(:label, attributes: shared, content: input) +
          @element.tag(:small, attributes: shared, content: options[:error])
        end
      end

      # <label>Input Label
      #   <input type="text" placeholder="large-4.columns" />
      # </label>
      class Input < Formular::Builder::Input # TODO: fuck inheritance.
        include ErrorWrap

        def call(attributes, options, tag=:input)
          return super unless options[:label]
          @element.tag(:label, attributes: {}, content: "#{options[:label]}#{super}")
        end
      end

      class Textarea < Formular::Builder::Textarea
        include ErrorWrap
      end

      # <input id="checkbox1" type="checkbox"><label for="checkbox1">Checkbox 1</label>
      class Checkbox < Formular::Builder::Checkbox

      end
    end
    # TODO: TEST that attributes hash is immutuable.
  end
end
