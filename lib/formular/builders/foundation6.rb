require 'formular/builders/basic'
require 'formular/elements'
require 'formular/element/foundation6'
require 'formular/element/foundation6/input_group'
module Formular
  module Builders
    class Foundation6 < Formular::Builders::Basic
      element_set(
        error_notification: Formular::Element::Foundation6::ErrorNotification,
        checkable_group_label: Formular::Element::Legend,
        checkbox: Formular::Element::Foundation6::Checkbox,
        radio: Formular::Element::Foundation6::Radio,
        stacked_checkbox: Formular::Element::Foundation6::StackedCheckbox,
        stacked_radio: Formular::Element::Foundation6::StackedRadio,
        input: Formular::Element::Foundation6::Input,
        input_group: Formular::Element::Foundation6::InputGroup,
        file: Formular::Element::Foundation6::File,
        select: Formular::Element::Foundation6::Select,
        textarea: Formular::Element::Foundation6::Textarea,
        wrapper: Formular::Element::Label,
        error_wrapper: Formular::Element::Foundation6::LabelWithError,
        error: Formular::Element::Foundation6::Error,
        hint: Formular::Element::Foundation6::Hint,
        submit: Formular::Element::Foundation6::Submit,
      )
    end # class Foundation6
  end # module Builders
end # module Formular
