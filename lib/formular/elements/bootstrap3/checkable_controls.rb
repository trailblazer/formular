require 'formular/elements'
require 'formular/elements/modules/container'
require 'formular/elements/modules/wrapped_control'
require 'formular/elements/module'

module Formular
  module Elements
    module Bootstrap3
      module CheckableControls
        module InlineCheckable
          include Formular::Elements::Module

          html(:with_group_label) do |input|
            input.wrapper do |_, output|
              output.concat input.group_label
              output.concat Formular::Elements::Div.(content: input.collection.map(&:checkable_label).join(''))
              output.concat input.hint
              output.concat input.error
            end
          end

          html(:wrapped) do |input|
            if input.has_group_label?
              input.to_html(context: :with_group_label)
            else
              input.wrapper do |_, output|
                output.concat input.collection.map(&:checkable_label).join('')
                output.concat input.hint
                output.concat input.error
              end
            end
          end
        end # class InlineCheckable

        class InlineRadio < Formular::Elements::Radio
          include Formular::Elements::Modules::WrappedControl
          include InlineCheckable

          tag :input
          add_option_keys :control_label_options
          set_default :control_label_options, { class: ['radio-inline'] }
        end# class InlineRadio

        class InlineCheckbox < Formular::Elements::Checkbox
          include Formular::Elements::Modules::WrappedControl
          include InlineCheckable

          tag :input
          set_default :control_label_options, { class: ['checkbox-inline'] }
        end # class InlineCheckbox

        module StackedCheckable
          include Formular::Elements::Module

          html(:wrapped) do |input|
            input.wrapper do |_, output|
              output.concat input.group_label
              input.collection.each do |control|
                output.concat control.inner_wrapper { control.checkable_label }
              end
              output.concat input.hint
              output.concat input.error
            end
          end

          class InnerWrapper < Formular::Elements::Container
            tag :div
          end

          module InstanceMethods
            def inner_wrapper(&block)
              InnerWrapper.(class: inner_wrapper_class, &block).to_s
            end
          end
        end # module StackedCheckable

        class Checkbox < Formular::Elements::Checkbox
          include Formular::Elements::Modules::WrappedControl
          include StackedCheckable

          tag :input

          def inner_wrapper_class
            ['checkbox']
          end
        end # class Checkbox

        class Radio < Formular::Elements::Radio
          include Formular::Elements::Modules::WrappedControl
          include StackedCheckable

          tag :input

          def inner_wrapper_class
            ['radio']
          end
        end # class Radio
      end # module CheckableControls
    end # module Bootstrap3
  end # module Elements
end # module Formular
