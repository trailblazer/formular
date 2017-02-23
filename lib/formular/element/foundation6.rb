require 'formular/elements'
require 'formular/element/modules/wrapped'
require 'formular/element/module'
require 'formular/element/foundation6/checkable_control'
require 'formular/element/foundation6/wrapped'
module Formular
  class Element
    module Foundation6
      include CheckableControl

      class ErrorNotification < Formular::Element::ErrorNotification
        set_default :class, ['callout alert']
      end

      module InputWithErrors
        include Formular::Element::Module
        set_default :class, ['is-invalid-input'], if: :has_errors?
      end # module InputWithErrors

      class Submit < Formular::Element::Button
        set_default :class, ['success', 'button']
        set_default :type, 'submit'
      end # class Submit

      class LabelWithError < Formular::Element::Label
        set_default :class, ['is-invalid-label']
      end # class LabelWithError

      class Error < Formular::Element::Error
        tag :span
        set_default :class, ['form-error', 'is-visible']
      end # class Error

      class Hint < Formular::Element::P
        set_default :class, ['help-text']
      end # class Hint

      class Input < Formular::Element::Input
        include Wrapped
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

      class Select < Formular::Element::Select
        include Wrapped
        include InputWithErrors
      end # class Select

      class Textarea < Formular::Element::Textarea
        include Wrapped
        include InputWithErrors
      end # class Textarea
    end # module Foundation6
  end # class Element
end # module Formular
