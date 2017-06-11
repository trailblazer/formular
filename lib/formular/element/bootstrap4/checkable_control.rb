require 'formular/elements'
require 'formular/element/modules/wrapped'
require 'formular/element/module'

module Formular
  class Element
    module Bootstrap4
      module CheckableControl
        class Checkbox < Formular::Element::Checkbox
          include Formular::Element::Modules::Wrapped
          set_default :class, ['form-check-input']

          html { closed_start_tag }
        end # class Checkbox

        class Radio < Formular::Element::Radio
          include Formular::Element::Modules::Wrapped
          set_default :class, ['form-check-input']

          def hidden_tag
            ''
          end
        end # class Radio

        module InlineCheckable
          include Formular::Element::Module

          set_default :label_options, { class: ['form-control-label'] }
          set_default :control_label_options, { class: ['form-check-inline'] }

          html(:wrapped) do |input|
            input.wrapper do
              concat input.group_label
              concat input.hidden_tag unless input.collection?
              if input.has_group_label?
                concat Formular::Element::Div.(content: input.to_html(context: :collection))
              else
                concat input.to_html(context: :collection)
              end
              concat input.hidden_tag if input.collection?
              concat input.hint
              concat input.error
            end
          end
        end # class InlineCheckable

        class InlineRadio < Radio
          include InlineCheckable
        end # class InlineRadio

        class InlineCheckbox < Checkbox
          include InlineCheckable
        end # class InlineCheckbox

        module StackedCheckable
          include Formular::Element::Module

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

          html(:collection) do |input|
            input.collection.map { |control|
              control.inner_wrapper { control.to_html(context: :checkable_label) }
            }.join('')
          end

          set_default :label_options, { class: ['form-control-label'] }
          set_default :control_label_options, { class: ['form-check-label'] }

          module InstanceMethods
            def inner_wrapper(&block)
              Formular::Element::Div.(class: ['form-check'], &block).to_s
            end
          end
        end # module StackedCheckable

        class StackedCheckbox < Checkbox
          include StackedCheckable
        end # class Checkbox

        class StackedRadio < Radio
          include StackedCheckable
        end # class StackedRadio
      end # module CheckableControl
    end # module Bootstrap4
  end # class Element
end # module Formular
