require 'formular/element'
require 'formular/elements'
require 'formular/elements/modules/container'
require 'formular/elements/module'
require 'formular/elements/bootstrap3'
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
            concat input.render(:default)
            concat input.error
          end

          html(:wrapped) do |input|
            input.wrapper do |wrapper|
              concat input.render(:label_column)
              concat wrapper.input_column_wrapper(class: input.column_class, content: input.render(:input_column))
            end
          end

          module InstanceMethods
            def column_class
              has_label? ? [] : builder.class.column_classes[:left_offset]
            end
          end
        end

        module WrappedCheckableControl
          include Formular::Elements::Module
          include WrappedControl

          html(:label_column) do |input|
            input.group_label
          end

          module InstanceMethods
            def column_class
              has_group_label? ? [] : builder.class.column_classes[:left_offset]
            end
          end
        end

        module StackedCheckableControl
          include Formular::Elements::Module
          include WrappedCheckableControl

          html(:input_column) do |input|
            input.collection.each do |control|
              concat control.inner_wrapper { control.checkable_label }
            end
            concat input.error
          end
        end

        module InlineCheckableControl
          include Formular::Elements::Module
          include WrappedCheckableControl

          html(:input_column) do |input|
            input.collection.each { |control| concat control.checkable_label }
            concat input.error
          end
        end

        Form = Class.new(Formular::Elements::Form) { set_default :class, ['form-horizontal'] }
        Select = Class.new(Formular::Elements::Bootstrap3::Select) { include WrappedControl }
        Textarea = Class.new(Formular::Elements::Bootstrap3::Textarea) { include WrappedControl }
        Input = Class.new(Formular::Elements::Bootstrap3::Input) { include WrappedControl }
        Submit = Class.new(Formular::Elements::Bootstrap3::Submit) { include WrappedControl }

        class InputColumnWrapper < Formular::Elements::Container
          set_default :class, :column_class
          tag 'div'

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

        class Checkbox < Formular::Elements::Bootstrap3::Checkbox
          include StackedCheckableControl

          tag "input"
        end

        class Radio < Formular::Elements::Bootstrap3::Radio
          include StackedCheckableControl

          tag "input"
        end

        class InlineCheckbox < Formular::Elements::Bootstrap3::InlineCheckbox
          include InlineCheckableControl

          tag "input"
        end

        class InlineRadio < Formular::Elements::Bootstrap3::InlineRadio
          include InlineCheckableControl

          tag "input"
        end
      end # module Horizontal
    end # module Bootstrap3
  end # module Elements
end # module Formular
