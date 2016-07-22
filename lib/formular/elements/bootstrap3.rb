require 'formular/element'
require 'formular/elements'
require 'formular/elements/modules/container'
require 'formular/elements/modules/wrapped_control'
require 'formular/elements/module'
require 'formular/elements/bootstrap3/checkable_control'
require 'formular/elements/bootstrap3/column_control'

module Formular
  module Elements
    module Bootstrap3
      include CheckableControl

      Label = Class.new(Formular::Elements::Label) { set_default :class, ['control-label'] }
      Row = Class.new(Formular::Elements::Div) { set_default :class, ['row'] }

      class Submit < Formular::Elements::Button
        set_default :class, ['btn', 'btn-default']
        set_default :type, 'submit'
      end # class Submit

      class ErrorNotification < Formular::Elements::ErrorNotification
        set_default :class, ['alert alert-danger']
      end

      class Error < Formular::Elements::Error
        tag :span
        set_default :class, ['help-block']
      end # class Error

      class Hint < Formular::Elements::Span
        set_default :class, ['help-block']
      end # class Hint

      class Input < Formular::Elements::Input
        include Formular::Elements::Modules::WrappedControl
        include Formular::Elements::Bootstrap3::ColumnControl

        set_default :class, ['form-control'], unless: :file_input?

        def file_input?
          attributes[:type] == 'file'
        end
      end # class Input

      class Select < Formular::Elements::Select
        include Formular::Elements::Modules::WrappedControl
        include Formular::Elements::Bootstrap3::ColumnControl

        set_default :class, ['form-control']
      end # class Select

      class Textarea < Formular::Elements::Textarea
        include Formular::Elements::Modules::WrappedControl
        include Formular::Elements::Bootstrap3::ColumnControl

        set_default :class, ['form-control']
      end # class Textarea

      class Wrapper < Formular::Elements::Div
        set_default :class, ['form-group']
      end # class Wrapper

      class ErrorWrapper < Formular::Elements::Div
        set_default :class, ['form-group', 'has-error']
      end # class Wrapper
    end # module Bootstrap3
  end # module Elements
end # module Formular
