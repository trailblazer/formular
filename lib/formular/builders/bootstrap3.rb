require 'formular/builders/basic'
require 'formular/element/bootstrap3'
require 'formular/element/bootstrap3/input_group'
module Formular
  module Builders
    class Bootstrap3 < Formular::Builders::Basic
      element_set(
        error_notification: Formular::Element::Bootstrap3::ErrorNotification,
        error: Formular::Element::Bootstrap3::Error,
        hint: Formular::Element::Bootstrap3::Hint,
        input: Formular::Element::Bootstrap3::Input,
        input_group: Formular::Element::Bootstrap3::InputGroup,
        checkbox: Formular::Element::Bootstrap3::Checkbox,
        radio: Formular::Element::Bootstrap3::Radio,
        select: Formular::Element::Bootstrap3::Select,
        inline_radio: Formular::Element::Bootstrap3::InlineRadio,
        inline_checkbox: Formular::Element::Bootstrap3::InlineCheckbox,
        label: Formular::Element::Bootstrap3::Label,
        checkable_group_label: Formular::Element::Bootstrap3::Label,
        textarea: Formular::Element::Bootstrap3::Textarea,
        wrapper: Formular::Element::Bootstrap3::Wrapper,
        error_wrapper: Formular::Element::Bootstrap3::ErrorWrapper,
        submit: Formular::Element::Bootstrap3::Submit,
        row: Formular::Element::Bootstrap3::Row,
        icon: Formular::Element::Bootstrap3::Icon
      )
    end # class Bootstrap3
  end # module Builders
end # module Formular
