require "formular/elements/form"
require "formular/elements/container"
require "formular/elements/bootstrap3"
module Formular
  module Elements
    module Bootstrap3
      module Horizontal
        module ControlHtml
          def html_block
            Proc.new() do |input|
              input.builder.wrapper(input.has_errors? ? {class: ["has-error"]} : {}) do |wrapper|
                concat input.label
                concat wrapper.input_column_wrapper({}, {content: input.control_html + input.error}).to_s
              end.to_s
            end
          end
        end

        class Form < Formular::Elements::Form
          attribute :class, ["form-horizontal"]
        end #class Form

        class Input < Formular::Elements::Bootstrap3::Input
          extend Formular::Elements::Bootstrap3::Horizontal::ControlHtml
          html &html_block

        end #class Input

        class File < Formular::Elements::Bootstrap3::File
          extend Formular::Elements::Bootstrap3::Horizontal::ControlHtml
          html &html_block

        end # class File

        class Textarea < Formular::Elements::Bootstrap3::Textarea
          extend Formular::Elements::Bootstrap3::Horizontal::ControlHtml
          html &html_block

        end #class Textarea

        class InputColumnWrapper < Formular::Elements::Container
          tag "div"

          def attributes
            @attributes.merge({class: builder.class.column_classes[:right_column]})
          end
        end #class InputColumnWrapper

        class Label < Formular::Elements::Bootstrap3::Label
          def attributes
            @attributes.merge({class: builder.class.column_classes[:left_column]})
          end
        end #class Label

        class Submit < Formular::Elements::Bootstrap3::Submit
          def attributes
            @attributes.merge({class: builder.class.column_classes[:left_offset] + builder.class.column_classes[:left_column]})
          end
        end #class Submit
      end #module Horizontal
    end #module Bootstrap3
  end #module Elements
end #module Formular
