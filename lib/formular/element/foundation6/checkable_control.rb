require 'formular/elements'
require 'formular/element/module'
require 'formular/element/foundation6/wrapped'
module Formular
  class Element
    module Foundation6
      module CheckableControl
        module Checkable
          include Formular::Element::Module
          include Formular::Element::Foundation6::Wrapped

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
          include Formular::Element::Module
          include Checkable

          html(:collection) do |input|
            input.collection.map { |control|
              input.builder.div(content: control.to_html(context: :checkable_label))
            }.join('')
          end
        end # class StackedCheckable

        class Checkbox < Formular::Element::Checkbox
          include Checkable
          set_default :label_options, { class: ['is-invalid-label'] }, if: :has_errors?
          set_default :control_label_options, { class: ['is-invalid-label'] }, if: :has_errors?

          html { closed_start_tag }
        end # class Checkbox

        class Radio < Formular::Element::Radio
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
  end # class Element
end # module Formular
