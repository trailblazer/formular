require "formular/elements/form"
require "formular/elements/container"
require "formular/elements/bootstrap3"
require "formular/elements/module"
module Formular
  module Elements
    module Bootstrap3
      module Horizontal
        module WrappedControl
          include Formular::Elements::Module

          html do |input|
            input.wrapper do |wrapper|
              concat input.label
              concat wrapper.input_column_wrapper(content: input.control_html + input.error).to_s
            end.to_s
          end
        end

        class Form < Formular::Elements::Form
          attribute :class, ["form-horizontal"]
        end #class Form

        class Input < Formular::Elements::Bootstrap3::Input
          include Formular::Elements::Bootstrap3::Horizontal::WrappedControl

        end #class Input

        class File < Formular::Elements::Bootstrap3::File
          include Formular::Elements::Bootstrap3::Horizontal::WrappedControl

        end # class File

        class Textarea < Formular::Elements::Bootstrap3::Textarea
          include Formular::Elements::Bootstrap3::Horizontal::WrappedControl

        end #class Textarea

        class Select < Formular::Elements::Bootstrap3::Select
          include Formular::Elements::Bootstrap3::Horizontal::WrappedControl

        end #class Select

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
