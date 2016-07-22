require 'formular/element'
require 'formular/elements'
require 'formular/elements/modules/container'
require 'formular/elements/module'
require 'formular/elements/bootstrap3'
require 'formular/elements/bootstrap3/checkable_control'
module Formular
  module Elements
    module Bootstrap3
      module Horizontal
        module WrappedControl
          include Formular::Elements::Module

          html(:label_column) do |input|
            input.label
          end

          html(:input_column) do |input|
            concat input.to_html(context: :default)
            concat input.hint
            concat input.error
          end

          html(:wrapped) do |input|
            input.wrapper do |wrapper|
              concat input.to_html(context: :label_column)
              concat wrapper.input_column_wrapper(
                              class: input.column_class,
                              content: input.to_html(context: :input_column)
                            )
            end
          end

          module InstanceMethods
            def column_class
              has_label? ? [] : builder.class.column_classes[:left_offset]
            end
          end
        end # module WrappedControl

        module WrappedCheckableControl
          include Formular::Elements::Module
          include WrappedControl

          html(:label_column) do |input|
            input.group_label
          end

          html(:input_column) do |input|
            concat input.hidden_tag
            concat input.to_html(context: :collection)
            concat input.hint
            concat input.error
          end

          module InstanceMethods
            def column_class
              has_group_label? ? [] : builder.class.column_classes[:left_offset]
            end
          end
        end # module WrappedCheckableControl

        class InputColumnWrapper < Formular::Elements::Div
          set_default :class, :column_class

          def column_class
            builder.class.column_classes[:right_column]
          end
        end # class InputColumnWrapper

        class Label < Formular::Elements::Bootstrap3::Label
          set_default :class, :column_class

          def column_class
            builder.class.column_classes[:left_column] + ['control-label']
          end
        end # class Label

        class Form < Formular::Elements::Form
          set_default :class, ['form-horizontal']
        end # class Form

        class Select < Formular::Elements::Bootstrap3::Select
          include WrappedControl
        end # class Select

        class Textarea < Formular::Elements::Bootstrap3::Textarea
          include WrappedControl
        end # class Textarea

        class Input < Formular::Elements::Bootstrap3::Input
          include WrappedControl
        end # class Input

        class InputGroup < Formular::Elements::Bootstrap3::InputGroup
          include WrappedControl
        end # class InputGroup

        class Submit < Formular::Elements::Bootstrap3::Submit
          include WrappedControl
        end # class Submit

        class Checkbox < Formular::Elements::Bootstrap3::Checkbox
          include Formular::Elements::Bootstrap3::CheckableControl::StackedCheckable
          include WrappedCheckableControl
        end # class Checkbox

        class Radio < Formular::Elements::Bootstrap3::Radio
          include Formular::Elements::Bootstrap3::CheckableControl::StackedCheckable
          include WrappedCheckableControl
        end # class Radio

        class InlineCheckbox < Formular::Elements::Bootstrap3::InlineCheckbox
          include WrappedCheckableControl
        end # class InlineCheckbox

        class InlineRadio < Formular::Elements::Bootstrap3::InlineRadio
          include WrappedCheckableControl
        end # class InlineRadio
      end # module Horizontal
    end # module Bootstrap3
  end # module Elements
end # module Formular
