require 'formular/builders/basic'
require 'formular/element/bootstrap4'
require 'formular/element/bootstrap3'
require 'formular/element/bootstrap4/input_group'

module Formular
  module Builders
    class Bootstrap4 < Formular::Builders::Basic
      element_set(
        error_notification: Formular::Element::Bootstrap3::ErrorNotification,
        error: Formular::Element::Bootstrap4::Error,
        hint: Formular::Element::Bootstrap4::Hint,
        input: Formular::Element::Bootstrap4::Input,
        input_group: Formular::Element::Bootstrap4::InputGroup,
        checkbox: Formular::Element::Bootstrap4::StackedCheckbox,
        radio: Formular::Element::Bootstrap4::StackedRadio,
        select: Formular::Element::Bootstrap4::Select,
        custom_select: Formular::Element::Bootstrap4::CustomSelect,
        custom_file: Formular::Element::Bootstrap4::CustomFile,
        custom_radio: Formular::Element::Bootstrap4::Inline::CustomRadio,
        custom_checkbox: Formular::Element::Bootstrap4::Inline::CustomCheckbox,
        custom_stacked_radio: Formular::Element::Bootstrap4::CustomStackedRadio,
        custom_stacked_checkbox: Formular::Element::Bootstrap4::CustomStackedCheckbox,
        inline_radio: Formular::Element::Bootstrap4::InlineRadio,
        inline_checkbox: Formular::Element::Bootstrap4::InlineCheckbox,
        label: Formular::Element::Label,
        checkable_group_label: Formular::Element::Legend,
        textarea: Formular::Element::Bootstrap4::Textarea,
        wrapper: Formular::Element::Bootstrap4::Wrapper,
        error_wrapper: Formular::Element::Bootstrap4::ErrorWrapper,
        submit: Formular::Element::Bootstrap4::Submit,
        row: Formular::Element::Bootstrap3::Row
      )
    end # class Bootstrap4
  end # module Builders
end # module Formular
