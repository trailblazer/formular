require 'formular/element'
require 'formular/elements'
require 'formular/element/modules/wrapped_control'
require 'formular/element/module'
require 'formular/element/bootstrap3/checkable_control'
require 'formular/element/bootstrap3/column_control'

module Formular
  class Element
    module Bootstrap3
      include CheckableControl

      Label = Class.new(Formular::Element::Label) { set_default :class, ['control-label'] }
      Row = Class.new(Formular::Element::Div) { set_default :class, ['row'] }

      class Submit < Formular::Element::Button
        set_default :class, ['btn', 'btn-default']
        set_default :type, 'submit'
      end # class Submit

      class ErrorNotification < Formular::Element::ErrorNotification
        set_default :class, ['alert alert-danger']
        set_default :role, 'alert'

      end

      class Error < Formular::Element::Error
        tag :span
        set_default :class, ['help-block']
      end # class Error

      class Hint < Formular::Element::Span
        set_default :class, ['help-block']
      end # class Hint

      class Input < Formular::Element::Input
        include Formular::Element::Modules::WrappedControl
        include Formular::Element::Bootstrap3::ColumnControl

        set_default :class, ['form-control'], unless: :file_input?

        def file_input?
          attributes[:type].to_s == 'file'
        end
      end # class Input

      class Select < Formular::Element::Select
        include Formular::Element::Modules::WrappedControl
        include Formular::Element::Bootstrap3::ColumnControl

        set_default :class, ['form-control']
      end # class Select

      class Textarea < Formular::Element::Textarea
        include Formular::Element::Modules::WrappedControl
        include Formular::Element::Bootstrap3::ColumnControl

        set_default :class, ['form-control']
      end # class Textarea

      class Wrapper < Formular::Element::Div
        set_default :class, ['form-group']
      end # class Wrapper

      class ErrorWrapper < Formular::Element::Div
        set_default :class, ['form-group', 'has-error']
      end # class Wrapper
    end # module Bootstrap3
  end # class Element
end # module Formular
