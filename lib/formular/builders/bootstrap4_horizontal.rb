require 'formular/builders/bootstrap4'
require 'formular/element/bootstrap3/horizontal'
require 'formular/element/bootstrap4/horizontal'
module Formular
  module Builders
    class Bootstrap4Horizontal < Formular::Builders::Bootstrap4
      element_set(
        input: Formular::Element::Bootstrap4::Horizontal::Input,
        custom_file: Formular::Element::Bootstrap4::Horizontal::CustomFile,
        input_group: Formular::Element::Bootstrap3::Horizontal::InputGroup,
        select: Formular::Element::Bootstrap3::Horizontal::Select,
        custom_select: Formular::Element::Bootstrap4::Horizontal::CustomSelect,
        checkbox: Formular::Element::Bootstrap4::Horizontal::Checkbox,
        custom_stacked_checkbox: Formular::Element::Bootstrap4::Horizontal::CustomStackedCheckbox,
        radio: Formular::Element::Bootstrap4::Horizontal::Radio,
        custom_stacked_radio: Formular::Element::Bootstrap4::Horizontal::CustomStackedRadio,
        inline_radio: Formular::Element::Bootstrap4::Horizontal::InlineRadio,
        custom_radio: Formular::Element::Bootstrap4::Horizontal::CustomRadio,
        inline_checkbox: Formular::Element::Bootstrap4::Horizontal::InlineCheckbox,
        custom_checkbox: Formular::Element::Bootstrap4::Horizontal::CustomCheckbox,
        label: Formular::Element::Bootstrap4::Horizontal::Label,
        legend: Formular::Element::Bootstrap4::Horizontal::Legend,
        checkable_group_label: Formular::Element::Bootstrap4::Horizontal::Legend,
        textarea: Formular::Element::Bootstrap3::Horizontal::Textarea,
        error_wrapper: Formular::Element::Bootstrap4::ErrorWrapper,
        input_column_wrapper: Formular::Element::Bootstrap3::Horizontal::InputColumnWrapper,
        submit: Formular::Element::Bootstrap4::Horizontal::Submit
      )
      inheritable_attr :column_classes

      #these options should be easily configurable
      self.column_classes = {
        left_column: ['col-sm-2'],
        right_column: ['col-sm-10'],
        left_offset: ['offset-sm-2']
      }
    end # class Bootstrap4Horizontal
  end # module Builders
end # module Formular
