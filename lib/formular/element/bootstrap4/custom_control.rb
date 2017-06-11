require 'formular/elements'
require 'formular/element/modules/wrapped'
require 'formular/element/bootstrap4'
require 'formular/element/bootstrap3'
require 'formular/element/module'

module Formular
  class Element
    module Bootstrap4
      module CustomControl
        module CustomCheckable
          include Formular::Element::Module
          include Formular::Element::Modules::Wrapped
          set_default :class, ['custom-control-input']
          set_default :label_options, { class: ['form-control-label'] }

          html(:checkable_label) do |input|
            Formular::Element::Label.(input.label_options) do
              concat input.to_html(context: :default)
              concat Formular::Element::Span.(class: ['custom-control-indicator'])
              if input.has_label?
                concat Formular::Element::Span.(class: ['custom-control-description'], content: input.label_text)
              end
            end
          end

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
        end # module CustomCheckbable

        module CustomStackable
          include Formular::Element::Module

          html(:collection) do |input|
            collection_html = input.collection.map { |item|
                item.to_html(context: :checkable_label)
              }.join

            Formular::Element::Div.(
              class: ['custom-controls-stacked'],
              content: collection_html
            )
          end
        end # module CustomStackable

        module Inline
          class CustomCheckbox < Formular::Element::Checkbox
            include CustomCheckable

            html { closed_start_tag }

            set_default :control_label_options, { class: ['custom-control custom-checkbox'] }
          end # class Checkbox

          class CustomRadio < Formular::Element::Radio
            include CustomCheckable
            set_default :control_label_options, { class: ['custom-control custom-radio'] }

            def hidden_tag
              ''
            end
          end # class Radio

          class CustomSelect < Formular::Element::Bootstrap3::Select
            set_default :class, ['custom-select']
            set_default :label_options, { class: ['form-control-label'] }
          end # class CustomSelect

          class CustomFile < Formular::Element::Input
            include Formular::Element::Modules::Wrapped
            include Formular::Element::Bootstrap3::ColumnControl

            set_default :class, ['custom-file-input']
            set_default :label_options, { class: ['form-control-label'] }
            set_default :type, 'file'

            rename_html_context(:default, :control)

            html do |input|
              Formular::Element::Label.(class: ['custom-file']) do
                concat input.to_html(context: :control)
                concat Formular::Element::Span.(class: ['custom-file-control'])
              end
            end
          end #class CustomFile
        end # module Inline

        class CustomSelect < Inline::CustomSelect
          rename_html_context(:default, :input)
          set_default :label_options, { class: ['form-control-label'] }

          html do |input|
            Formular::Element::Div.(content: input.to_html(context: :input))
          end
        end # class Select

        class CustomFile < Inline::CustomFile
          rename_html_context(:default, :input)
          set_default :label_options, { class: ['form-control-label'] }

          html do |input|
            Formular::Element::Div.(content: input.to_html(context: :input))
          end
        end # class File

        class CustomStackedRadio < Inline::CustomRadio
          include CustomStackable
        end # class StackedRadio

        class CustomStackedCheckbox < Inline::CustomCheckbox
          include CustomStackable
        end # class StackedCheckbox
      end # module CustomControl
    end  # module Bootstrap4
  end  # class Element
end # module Formular
