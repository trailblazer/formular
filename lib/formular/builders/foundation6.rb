require 'formular/builders/basic'
require 'formular/elements'
require 'formular/elements/foundation6'
module Formular
  module Builders
    class Foundation6 < Formular::Builders::Basic
      element_set(
        checkable_group_label: Formular::Elements::Legend,
        checkbox: Formular::Elements::Foundation6::Checkbox,
        radio: Formular::Elements::Foundation6::Radio,
        stacked_checkbox: Formular::Elements::Foundation6::StackedCheckbox,
        stacked_radio: Formular::Elements::Foundation6::StackedRadio,
        input: Formular::Elements::Foundation6::Input,
        input_group: Formular::Elements::Foundation6::InputGroup,
        file: Formular::Elements::Foundation6::File,
        select: Formular::Elements::Foundation6::Select,
        textarea: Formular::Elements::Foundation6::Textarea,
        wrapper: Formular::Elements::Label,
        error_wrapper: Formular::Elements::Foundation6::LabelWithError,
        error: Formular::Elements::Foundation6::Error,
        hint: Formular::Elements::Foundation6::Hint,
        submit: Formular::Elements::Foundation6::Submit,
      )
    end # class Foundation6
  end # module Builders
end # module Formular
