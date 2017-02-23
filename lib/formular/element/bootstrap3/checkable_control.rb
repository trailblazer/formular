require 'formular/elements'
require 'formular/element/modules/wrapped'
require 'formular/element/module'

module Formular
  class Element
    module Bootstrap3
      module CheckableControl
        module InlineCheckable
          include Formular::Element::Module

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

        class InlineRadio < Formular::Element::Radio
          include Formular::Element::Modules::Wrapped
          include InlineCheckable

          add_option_keys :control_label_options
          set_default :control_label_options, { class: ['radio-inline'] }

          def hidden_tag
            ''
          end
        end# class InlineRadio

        class InlineCheckbox < Formular::Element::Checkbox
          include Formular::Element::Modules::Wrapped
          include InlineCheckable

          set_default :control_label_options, { class: ['checkbox-inline'] }

          html { closed_start_tag }
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

          module InstanceMethods
            def inner_wrapper(&block)
              Formular::Element::Div.(class: inner_wrapper_class, &block).to_s
            end
          end
        end # module StackedCheckable

        class Checkbox < Formular::Element::Checkbox
          include Formular::Element::Modules::Wrapped
          include StackedCheckable

          html { closed_start_tag }

          def inner_wrapper_class
            ['checkbox']
          end
        end # class Checkbox

        class Radio < Formular::Element::Radio
          include Formular::Element::Modules::Wrapped
          include StackedCheckable

          def inner_wrapper_class
            ['radio']
          end

          def hidden_tag
            ''
          end
        end # class Radio
      end # module CheckableControl
    end # module Bootstrap3
  end # class Element
end # module Formular
