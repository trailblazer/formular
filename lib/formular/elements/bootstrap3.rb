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

      class Error < Formular::Element
        include Formular::Elements::Modules::Container
        tag :span
        set_default :class, ['help-block']

      end # class Error

      class Input < Formular::Elements::Input
        include Formular::Elements::Modules::WrappedControl

        set_default :class, ['form-control'], unless: :file_input?

        def control_html
          Formular::Elements::Input.renderer.call(self)
        end

        def file_input?
          attributes[:type] == "file"
        end
      end # class Input

      class Select < Formular::Elements::Select
        include Formular::Elements::Modules::WrappedControl

        set_default :class, ['form-control']

        def control_html
          Formular::Elements::Select.renderer.call(self)
        end
      end # class Select

      class Textarea < Formular::Elements::Textarea
        include Formular::Elements::Modules::WrappedControl
        set_default :class, ['form-control']

        def control_html
          Formular::Elements::Textarea.renderer.call(self)
        end
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
