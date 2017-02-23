require 'formular/element'
require 'formular/elements'
require 'formular/element/module'
require 'formular/element/bootstrap3'
require 'formular/element/bootstrap3/checkable_control'
module Formular
  class Element
    module Bootstrap3
      module Horizontal
        module Wrapped
          include Formular::Element::Module

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
        end # module Wrapped

        module WrappedCheckableControl
          include Formular::Element::Module
          include Wrapped

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

        class InputColumnWrapper < Formular::Element::Div
          set_default :class, :column_class

          def column_class
            builder.class.column_classes[:right_column]
          end
        end # class InputColumnWrapper

        class Label < Formular::Element::Bootstrap3::Label
          set_default :class, :column_class

          def column_class
            builder.class.column_classes[:left_column] + ['control-label']
          end
        end # class Label

        class Form < Formular::Element::Form
          set_default :class, ['form-horizontal']
        end # class Form

        class Select < Formular::Element::Bootstrap3::Select
          include Wrapped
        end # class Select

        class Textarea < Formular::Element::Bootstrap3::Textarea
          include Wrapped
        end # class Textarea

        class Input < Formular::Element::Bootstrap3::Input
          include Wrapped
        end # class Input

        class InputGroup < Formular::Element::Bootstrap3::InputGroup
          include Wrapped

          html(:start) do |input|
            wrapper = input.wrapper
            concat wrapper.start
            concat input.to_html(context: :label_column)
            concat wrapper.input_column_wrapper(class: input.column_class).start
            concat Formular::Element::Bootstrap3::InputGroup::Wrapper.().start
          end

          html(:end) do |input|
            wrapper = input.wrapper
            concat Formular::Element::Bootstrap3::InputGroup::Wrapper.().end
            concat wrapper.input_column_wrapper.end
            concat wrapper.end
          end
        end # class InputGroup

        class Submit < Formular::Element::Bootstrap3::Submit
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

        class Checkbox < Formular::Element::Bootstrap3::Checkbox
          include Formular::Element::Bootstrap3::CheckableControl::StackedCheckable
          include WrappedCheckableControl
        end # class Checkbox

        class Radio < Formular::Element::Bootstrap3::Radio
          include Formular::Element::Bootstrap3::CheckableControl::StackedCheckable
          include WrappedCheckableControl
        end # class Radio

        class InlineCheckbox < Formular::Element::Bootstrap3::InlineCheckbox
          include WrappedCheckableControl
        end # class InlineCheckbox

        class InlineRadio < Formular::Element::Bootstrap3::InlineRadio
          include WrappedCheckableControl
        end # class InlineRadio
      end # module Horizontal
    end # module Bootstrap3
  end # class Element
end # module Formular
