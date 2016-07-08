require 'formular/builders/basic'
require 'formular/elements'
require 'formular/elements/bootstrap3'
require 'formular/elements/bootstrap3/inline'
module Formular
  module Builders
    class Bootstrap3Inline < Formular::Builders::Basic
      element_set(
        form: Formular::Elements::Bootstrap3::Inline::Form,
        error: Formular::Elements::Bootstrap3::Error,
        hint: Formular::Elements::Bootstrap3::Hint,
        input: Formular::Elements::Bootstrap3::Input,
        input_group: Formular::Elements::Bootstrap3::InputGroup,
        select: Formular::Elements::Bootstrap3::Select,
        checkbox: Formular::Elements::Bootstrap3::Checkbox,
        radio: Formular::Elements::Bootstrap3::Radio,
        inline_radio: Formular::Elements::Bootstrap3::InlineRadio,
        inline_checkbox: Formular::Elements::Bootstrap3::InlineCheckbox,
        label: Formular::Elements::Bootstrap3::Label,
        checkable_group_label: Formular::Elements::Bootstrap3::Label,
        textarea: Formular::Elements::Bootstrap3::Textarea,
        wrapper: Formular::Elements::Bootstrap3::Wrapper,
        error_wrapper: Formular::Elements::Bootstrap3::ErrorWrapper,
        submit: Formular::Elements::Bootstrap3::Submit
      )
    end # class Bootstrap3Inline
  end # module Builders
end # module Formular
