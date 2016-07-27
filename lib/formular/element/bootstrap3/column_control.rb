require 'formular/element/module'

module Formular
  class Element
    module Bootstrap3
      # this module simplifies the process of
      # creating inline column controls
      # you will need to manually wrap your element in a row
      module ColumnControl
        include Formular::Element::Module

        add_option_keys :inline_col_class, :stacked_col_class
        set_default :wrapper_options, :inline_wrapper_class, if: :inline_column?

        def inline_wrapper_class
          { class: options[:inline_col_class] }
        end

        def inline_column?
          options[:inline_col_class]
        end

        def stacked_column?
          options[:stacked_col_class]
        end

        rename_html_context(:default, :no_cols)

        html(:stacked_column) do |element|
          element.builder.row {
            element.builder.div(
              class: element.options[:stacked_col_class],
              content: element.to_html(context: :no_cols)
            )
          }
        end

        html do |element|
          context = element.stacked_column? ? :stacked_column : :no_cols
          element.to_html(context: context)
        end
      end # module ColumnControl
    end # module Bootstrap3
  end # class Element
end # module Formular
