require 'formular/builders/basic'
require 'formular/elements/bootstrap3'
module Formular
  module Builders
    class Bootstrap3 < Formular::Builders::Basic
      element_set(
        error: Formular::Elements::Bootstrap3::Error,
        hint: Formular::Elements::Bootstrap3::Hint,
        input: Formular::Elements::Bootstrap3::Input,
        input_group: Formular::Elements::Bootstrap3::InputGroup,
        checkbox: Formular::Elements::Bootstrap3::Checkbox,
        radio: Formular::Elements::Bootstrap3::Radio,
        select: Formular::Elements::Bootstrap3::Select,
        inline_radio: Formular::Elements::Bootstrap3::InlineRadio,
        inline_checkbox: Formular::Elements::Bootstrap3::InlineCheckbox,
        label: Formular::Elements::Bootstrap3::Label,
        checkable_group_label: Formular::Elements::Bootstrap3::Label,
        textarea: Formular::Elements::Bootstrap3::Textarea,
        wrapper: Formular::Elements::Bootstrap3::Wrapper,
        error_wrapper: Formular::Elements::Bootstrap3::ErrorWrapper,
        submit: Formular::Elements::Bootstrap3::Submit
      )
    end # class Bootstrap3
  end # module Builders
end # module Formular
