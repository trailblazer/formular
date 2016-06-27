require 'formular/element'
require 'formular/elements'
require 'formular/elements/modules/container'
require 'formular/elements/modules/wrapped_control'
require 'formular/elements/module'
module Formular
  module Elements
    module Bootstrap3
      Label = Class.new(Formular::Elements::Label) { set_default :class, ['control-label'] }
      Submit = Class.new(Formular::Elements::Submit) { set_default :class, ['btn', 'btn-default'] }

      class Error < Formular::Elements::Container
        tag :span
        set_default :class, ['help-block']

      end # class Error

      class Input < Formular::Elements::Input
        include Formular::Elements::Modules::WrappedControl

        set_default :class, ['form-control'], unless: :file_input?

        def file_input?
          attributes[:type] == "file"
        end
      end # class Input

      module InlineCheckable
        include Formular::Elements::Module

        html(:wrapped) do |input|
          input.wrapper do
            concat input.group_label
            input.collection.each do |control|
              concat control.checkable_label
            end
            concat input.error
          end
        end
      end

      module StackedCheckable
        include Formular::Elements::Module

        html(:wrapped) do |input|
          input.wrapper do
            concat input.group_label
            input.collection.each do |control|
              concat control.inner_wrapper { control.checkable_label }
            end
            concat input.error
          end
        end

        class InnerWrapper < Formular::Elements::Container
          tag 'div'
        end

        module InstanceMethods
          def inner_wrapper(&block)
            InnerWrapper.(class: inner_wrapper_class, &block).to_s
          end
        end
      end

      class InlineRadio < Formular::Elements::Radio
        include Formular::Elements::Modules::WrappedControl
        include InlineCheckable

        tag "input"
        add_option_keys [:control_label_options]
        set_default :control_label_options, { class: ["radio-inline"] }
      end

      class InlineCheckbox < Formular::Elements::Checkbox
        include Formular::Elements::Modules::WrappedControl
        include InlineCheckable

        tag 'input'
        set_default :control_label_options, { class: ["checkbox-inline"] }
      end # class Checkbox

      class Checkbox < Formular::Elements::Checkbox
        include Formular::Elements::Modules::WrappedControl
        include StackedCheckable

        tag 'input'

        def inner_wrapper_class
          ['checkbox']
        end
      end # class Checkbox

      class Radio < Formular::Elements::Radio
        include Formular::Elements::Modules::WrappedControl
        include StackedCheckable

        tag 'input'

        def inner_wrapper_class
          ['radio']
        end
      end # class Radio

      class Select < Formular::Elements::Select
        include Formular::Elements::Modules::WrappedControl

        set_default :class, ['form-control']
      end # class Select

      class Textarea < Formular::Elements::Textarea
        include Formular::Elements::Modules::WrappedControl
        set_default :class, ['form-control']
      end # class Textarea

      class Wrapper < Formular::Element
        include Formular::Elements::Modules::Container
        tag 'div'
        set_default :class, ['form-group']
      end # class Wrapper

      class ErrorWrapper < Formular::Elements::Bootstrap3::Wrapper
        tag 'div'
        set_default :class, ['has-error']
      end # class Wrapper
    end # module Bootstrap3
  end # module Elements
end # module Formular
