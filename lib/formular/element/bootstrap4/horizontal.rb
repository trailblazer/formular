require 'formular/element'
require 'formular/elements'
require 'formular/element/module'
require 'formular/element/bootstrap4'
require 'formular/element/bootstrap4/checkable_control'
require 'formular/element/bootstrap4/custom_control'
require 'formular/element/bootstrap3/horizontal'
module Formular
  class Element
    module Bootstrap4
      module Horizontal
        class Label < Formular::Element::Label
          set_default :class, :column_class

          def column_class
            builder.class.column_classes[:left_column] + ['col-form-label']
          end
        end # class Label

        class Legend < Formular::Element::Legend
          set_default :class, :column_class

          def column_class
            builder.class.column_classes[:left_column] + ['col-form-legend']
          end
        end # class Legend

        class Input < Formular::Element::Bootstrap4::Input
          include Formular::Element::Bootstrap3::Horizontal::Wrapped
        end # class Input

        class CustomFile < Formular::Element::Bootstrap4::CustomFile
          include Formular::Element::Bootstrap3::Horizontal::Wrapped
        end # class CustomFile

        class CustomSelect < Formular::Element::Bootstrap4::CustomSelect
          include Formular::Element::Bootstrap3::Horizontal::Wrapped
        end # class CustomFile

        class Submit < Formular::Element::Bootstrap4::Submit
          self.html_context = :wrapped

          html(:wrapped) do |input|
            input.wrapper do |wrapper|
              wrapper.input_column_wrapper(
                        class: input.builder.class.column_classes[:left_offset],
                        content: input.to_html(context: :default)
                      )
            end
          end
        end # class Submit

        class Checkbox < Formular::Element::Bootstrap4::StackedCheckbox
          include Formular::Element::Bootstrap3::Horizontal::WrappedCheckableControl
        end # class Checkbox

        class CustomStackedCheckbox < Formular::Element::Bootstrap4::CustomStackedCheckbox
          include Formular::Element::Bootstrap3::Horizontal::WrappedCheckableControl
        end # class CustomStackedCheckbox

        class Radio < Formular::Element::Bootstrap4::StackedRadio
          include Formular::Element::Bootstrap3::Horizontal::WrappedCheckableControl
        end # class Radio

        class CustomStackedRadio < Formular::Element::Bootstrap4::CustomStackedRadio
          include Formular::Element::Bootstrap3::Horizontal::WrappedCheckableControl
        end # class CustomStackedRadio

        class InlineCheckbox < Formular::Element::Bootstrap4::InlineCheckbox
          include Formular::Element::Bootstrap3::Horizontal::WrappedCheckableControl
        end # class InlineCheckbox

        class CustomCheckbox < Formular::Element::Bootstrap4::Inline::CustomCheckbox
          include Formular::Element::Bootstrap3::Horizontal::WrappedCheckableControl
        end # class CustomCheckbox

        class InlineRadio < Formular::Element::Bootstrap4::InlineRadio
          include Formular::Element::Bootstrap3::Horizontal::WrappedCheckableControl
        end # class InlineRadio

        class CustomRadio < Formular::Element::Bootstrap4::Inline::CustomRadio
          include Formular::Element::Bootstrap3::Horizontal::WrappedCheckableControl
        end # class CustomRadio
      end # module Horizontal
    end # module Bootstrap4
  end # class Element
end # module Formular
