require 'formular/builders/bootstrap3'
require 'formular/element/bootstrap3/horizontal'
module Formular
  module Builders
    class Bootstrap3Horizontal < Formular::Builders::Bootstrap3
      element_set(
        form: Formular::Element::Bootstrap3::Horizontal::Form,
        input: Formular::Element::Bootstrap3::Horizontal::Input,
        input_group: Formular::Element::Bootstrap3::Horizontal::InputGroup,
        select: Formular::Element::Bootstrap3::Horizontal::Select,
        checkbox: Formular::Element::Bootstrap3::Horizontal::Checkbox,
        radio: Formular::Element::Bootstrap3::Horizontal::Radio,
        inline_radio: Formular::Element::Bootstrap3::Horizontal::InlineRadio,
        inline_checkbox: Formular::Element::Bootstrap3::Horizontal::InlineCheckbox,
        label: Formular::Element::Bootstrap3::Horizontal::Label,
        checkable_group_label: Formular::Element::Bootstrap3::Horizontal::Label,
        textarea: Formular::Element::Bootstrap3::Horizontal::Textarea,
        error_wrapper: Formular::Element::Bootstrap3::ErrorWrapper,
        input_column_wrapper: Formular::Element::Bootstrap3::Horizontal::InputColumnWrapper,
        submit: Formular::Element::Bootstrap3::Horizontal::Submit
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
