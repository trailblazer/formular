require 'formular/elements'
require 'formular/elements/module'
require 'formular/elements/foundation6/wrapped_control'
module Formular
  module Elements
    module Foundation6
      module CheckableControls
        module Checkable
          include Formular::Elements::Module
          include Formular::Elements::Foundation6::WrappedControl

          set_default :label_options, { class: ['is-invalid-label'] }, if: :has_errors?
          set_default :control_label_options, { class: ['is-invalid-label'] }, if: :has_errors?

          html(:wrapped) do |input|
            input.wrapper do
              concat input.group_label
              concat input.hidden_tag unless input.collection?
              concat input.to_html(context: :collection)
              concat input.hidden_tag if input.collection?
              concat input.hint
              concat input.error
            end
          end

          module InstanceMethods
            def wrapper(&block)
              builder.fieldset(Attributes[options[:wrapper_options]], &block)
            end
          end
        end # class Checkable

        module StackedCheckable
          include Formular::Elements::Module
          include Checkable

          html(:collection) do |input|
            input.collection.map { |control|
              input.builder.div(content: control.to_html(context: :checkable_label))
            }.join('')
          end
        end # class StackedCheckable

        class Checkbox < Formular::Elements::Checkbox
          include Checkable

          set_default :value, '1' # instead of reader value
          set_default :label_options, { class: ['is-invalid-label'] }, if: :has_errors?
          set_default :control_label_options, { class: ['is-invalid-label'] }, if: :has_errors?

          html { closed_start_tag }
        end # class Checkbox

        class Radio < Formular::Elements::Radio
          include Checkable

          def hidden_tag
            ''
          end
        end # class Radio

        class StackedRadio < Radio
          include StackedCheckable
        end # class StackedRadio

        class StackedCheckbox < Checkbox
          include StackedCheckable
        end # class StackedCheckbox
      end # module CheckableControls
    end #module Foundation6
  end # module Elements
end # module Formular
