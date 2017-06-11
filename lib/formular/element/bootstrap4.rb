require 'formular/element'
require 'formular/elements'
require 'formular/element/modules/wrapped'
require 'formular/element/module'
require 'formular/element/bootstrap4/checkable_control'
require 'formular/element/bootstrap4/custom_control'
require 'formular/element/bootstrap3'
require 'formular/element/bootstrap3/column_control'

module Formular
  class Element
    module Bootstrap4
      include CheckableControl
      include CustomControl

      class Submit < Formular::Element::Button
        set_default :class, ['btn', 'btn-secondary']
        set_default :type, 'submit'
      end # class Submit

      class Error < Formular::Element::Error
        tag :div
        set_default :class, ['form-control-feedback']
      end # class Error

      class Hint < Formular::Element::Small
        set_default :class, ['form-text', 'text-muted']
      end # class Hint

      class Select < Formular::Element::Bootstrap3::Select
        set_default :label_options, { class: ['form-control-label'] }
      end # class Textarea


      class Textarea < Formular::Element::Bootstrap3::Textarea
        set_default :label_options, { class: ['form-control-label'] }
      end # class Textarea

      class Input < Formular::Element::Bootstrap3::Input
        set_default :label_options, { class: ['form-control-label'] }

        def input_class
          return %(form-control-file) if options[:type].to_s == 'file'

          has_errors? ? ['form-control', 'form-control-danger'] : ['form-control']
        end
      end # class Input

      class Wrapper < Formular::Element::Fieldset
        set_default :class, ['form-group']
      end # class Wrapper

      class ErrorWrapper < Formular::Element::Fieldset
        set_default :class, ['form-group', 'has-danger']
      end # class Wrapper
    end # module Bootstrap3
  end # class Element
end # module Formular
