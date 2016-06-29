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

        html(:wrapped) do |input|
          input.wrapper do |_, output|
            output.concat input.label_text
            output.concat input.to_html(context: :default)
            output.concat input.hint
            output.concat input.error
          end.to_s
        end
      end

      module Checkable
        include Formular::Elements::Module

        set_default :label_options, { class: ['is-invalid-label'] }, if: :has_errors?
        set_default :control_label_options, { class: ['is-invalid-label'] }, if: :has_errors?

        html(:wrapped) do |input|
          input.wrapper do |_, output|
            output.concat input.group_label
            input.collection.each { |control| output.concat control.checkable_label }
            output.concat input.hint
            output.concat input.error
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

        html(:wrapped) do |input|
          input.wrapper do |_, output|
            output.concat input.group_label
            input.collection.each do |control|
              output.concat input.builder.div(content: control.checkable_label).to_s
            end
            output.concat input.hint
            output.concat input.error
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

      class Error < Formular::Elements::Error
        tag :span
        set_default :class, ['form-error', 'is-visible']
      end # class Error

      class Hint < Formular::Elements::Hint
        tag :p
        set_default :class, ['help-text']
      end

      class Checkbox < Formular::Elements::Checkbox
        include WrappedControl
        include Checkable

        tag 'input'
        set_default :label_options, { class: ['is-invalid-label'] }, if: :has_errors?
        set_default :control_label_options, { class: ['is-invalid-label'] }, if: :has_errors?

      end # class Input

      class Radio < Formular::Elements::Radio
        include WrappedControl
        include Checkable

        tag 'input'
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
      end # class Input

      class File < Input
        tag 'input'
        set_default :type, 'file'
        set_default :class, ['show-for-sr']
        set_default :label_options, { class: ['button'] }

        self.html_context = :wrapped

        html(:wrapped) do |input, output|
          output.concat input.label
          output.concat input.to_html(context: :default)
          output.concat input.hint
          output.concat input.error
        end
      end # class Input

      class Select < Formular::Elements::Select
        include WrappedControl
        include InputWithErrors
      end # class Select

      class Textarea < Formular::Elements::Textarea
        include WrappedControl
        include InputWithErrors
      end # class Select
    end # module Foundation6
  end # module Elements
end # module Formular
