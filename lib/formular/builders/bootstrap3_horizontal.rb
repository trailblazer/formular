require 'formular/builders/basic'
require 'formular/elements'
require 'formular/elements/bootstrap3'
require 'formular/elements/bootstrap3/horizontal'
module Formular
  module Builders
    class Bootstrap3Horizontal < Formular::Builders::Bootstrap3
      element_set(
        form: Formular::Elements::Bootstrap3::Horizontal::Form,
        error: Formular::Elements::Bootstrap3::Error,
        hint: Formular::Elements::Bootstrap3::Hint,
        input: Formular::Elements::Bootstrap3::Horizontal::Input,
        input_group: Formular::Elements::Bootstrap3::Horizontal::InputGroup,
        select: Formular::Elements::Bootstrap3::Horizontal::Select,
        checkbox: Formular::Elements::Bootstrap3::Horizontal::Checkbox,
        radio: Formular::Elements::Bootstrap3::Horizontal::Radio,
        inline_radio: Formular::Elements::Bootstrap3::Horizontal::InlineRadio,
        inline_checkbox: Formular::Elements::Bootstrap3::Horizontal::InlineCheckbox,
        label: Formular::Elements::Bootstrap3::Horizontal::Label,
        checkable_group_label: Formular::Elements::Bootstrap3::Horizontal::Label,
        textarea: Formular::Elements::Bootstrap3::Horizontal::Textarea,
        wrapper: Formular::Elements::Bootstrap3::Wrapper,
        error_wrapper: Formular::Elements::Bootstrap3::ErrorWrapper,
        input_column_wrapper: Formular::Elements::Bootstrap3::Horizontal::InputColumnWrapper,
        submit: Formular::Elements::Bootstrap3::Horizontal::Submit
      )
      inheritable_attr :column_classes

      #these options should be easily configurable
      self.column_classes = {
        left_column: ['col-sm-2'],
        right_column: ['col-sm-10'],
        left_offset: ['col-sm-offset-2']
      }
    end # class Bootstrap3Horizontal
  end # module Builders
end # module Formular
