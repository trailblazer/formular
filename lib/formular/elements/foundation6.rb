require 'formular/elements'
require 'formular/elements/modules/wrapped_control'
require 'formular/elements/module'
require 'formular/elements/foundation6/input_groups'
require 'formular/elements/foundation6/checkable_controls'
require 'formular/elements/foundation6/wrapped_control'
module Formular
  module Elements
    module Foundation6
      include InputGroups
      include CheckableControls

      module InputWithErrors
        include Formular::Elements::Module
        set_default :class, ['is-invalid-input'], if: :has_errors?
      end # module InputWithErrors

      class Submit < Formular::Elements::Button
        set_default :class, ['success', 'button']
        set_default :type, 'submit'
      end # class Submit

      class LabelWithError < Formular::Elements::Label
        set_default :class, ['is-invalid-label']
      end # class LabelWithError

      class Error < Formular::Elements::Error
        tag :span
        set_default :class, ['form-error', 'is-visible']
      end # class Error

      class Hint < Formular::Elements::P
        set_default :class, ['help-text']
      end # class Hint

      class Input < Formular::Elements::Input
        include WrappedControl
        include InputWithErrors
      end # class Input

      class File < Input
        set_default :type, 'file'
        set_default :class, ['show-for-sr']
        set_default :label_options, { class: ['button'] }

        self.html_context = :wrapped

        html(:wrapped) do |input|
          concat input.label
          concat input.to_html(context: :default)
          concat input.hint
          concat input.error
        end
      end # class File

      class Select < Formular::Elements::Select
        include WrappedControl
        include InputWithErrors
      end # class Select

      class Textarea < Formular::Elements::Textarea
        include WrappedControl
        include InputWithErrors
      end # class Textarea
    end # module Foundation6
  end # module Elements
end # module Formular
