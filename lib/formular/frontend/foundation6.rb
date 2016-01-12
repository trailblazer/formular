module Formular
  module Foundation6
    # <label class="error">Error
    #   <input type="text" class="error" />
    # </label>
    # <small class="error">Invalid entry</small>
    class Builder < Formular::Builder
      def render_input_error(attributes, options)
        shared = { class: [:error] }

        input = @element.tag(:input, attributes: shared.merge(attributes))

        @element.tag(:label, attributes: shared, content: input) +
        @element.tag(:small, attributes: shared, content: options[:error])
      end
    end
    # TODO: TEST that attributes hash is immutuable.
  end
end
