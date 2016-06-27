require 'formular/element'
require 'formular/elements'
require 'formular/elements/modules/container'
require 'formular/elements/modules/wrapped_control'
require 'formular/elements/module'
module Formular
  module Elements
    module Foundation6
      Submit = Class.new(Formular::Elements::Submit) { set_default :class, ['success', 'button'] }

      module WrappedControl
        include Formular::Elements::Module
        include Formular::Elements::Modules::WrappedControl

        html do |input|
          input.wrapper do
            concat input.label_text
            concat input.control_html
            concat input.error
          end.to_s
        end
      end

      module Checkable
        include Formular::Elements::Module

        set_default :label_options, { class: ['is-invalid-label'] }, if: :has_errors?
        set_default :control_label_options, { class: ['is-invalid-label'] }, if: :has_errors?

        html do |input|
          input.wrapper do
            concat input.group_label
            input.collection.each do |control|
              concat control.checkable_label
            end
            concat input.error
          end.to_s
        end

        module InstanceMethods
          def wrapper(&block)
            builder.fieldset(Attributes[options[:wrapper_options]], &block)
          end
        end
      end

      module StackedCheckable
        include Formular::Elements::Module
        include Checkable

        html do |input|
          input.wrapper do
            concat input.group_label
            input.collection.each do |control|
              concat input.builder.div(content: control.checkable_label).to_s
            end
            concat input.error
          end.to_s
        end
      end

      module InputWithErrors
        include Formular::Elements::Module
        set_default :class, ['is-invalid-input'], if: :has_errors?
      end

      class LabelWithError < Formular::Elements::Label
        tag "label"
        set_default :class, ['is-invalid-label']
      end

      class Error < Formular::Elements::Container
        tag :span
        set_default :class, ['form-error is-visible']
      end # class Error

      class Checkbox < Formular::Elements::Checkbox
        include WrappedControl
        include Checkable

        tag 'input'
        set_default :label_options, { class: ['is-invalid-label'] }, if: :has_errors?
        set_default :control_label_options, { class: ['is-invalid-label'] }, if: :has_errors?

        def control_html
          Formular::Elements::Checkbox.renderer.call(self)
        end
      end # class Input

      class Radio < Formular::Elements::Radio
        include WrappedControl
        include Checkable

        tag 'input'

        def control_html
          Formular::Elements::Radio.renderer.call(self)
        end
      end

      class StackedRadio < Radio
        include StackedCheckable
        tag 'input'
      end

      class StackedCheckbox < Checkbox
        include StackedCheckable
        tag 'input'
      end

      class Input < Formular::Elements::Input
        include WrappedControl
        include InputWithErrors

        def control_html
          Formular::Elements::Input.renderer.call(self)
        end
      end # class Input

      class File < Input
        tag 'input'
        set_default :type, 'file'
        set_default :class, ['show-for-sr']
        set_default :label_options, { class: ['button'] }

        html do |input|
          concat input.label
          concat input.control_html
          concat input.error
        end
      end # class Input

      class Select < Formular::Elements::Select
        include WrappedControl
        include InputWithErrors

        def control_html
          Formular::Elements::Select.renderer.call(self)
        end
      end # class Select

      class Textarea < Formular::Elements::Textarea
        include WrappedControl
        include InputWithErrors

        def control_html
          Formular::Elements::Textarea.renderer.call(self)
        end
      end # class Select
    end # module Foundation6
  end # module Elements
end # module Formular
