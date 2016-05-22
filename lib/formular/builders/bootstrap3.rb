require "formular/builders/basic"
require "formular/elements/bootstrap3"
require "formular/elements/bootstrap3/horizontal"
require "formular/elements/bootstrap3/inline"
require "formular/elements/form"
module Formular
  module Builders
    class Bootstrap3 < Formular::Builders::Basic
      self.elements = {
        form: Formular::Elements::Form,
        error: Formular::Elements::Bootstrap3::Error,
        input: Formular::Elements::Bootstrap3::Input,
        file: Formular::Elements::Bootstrap3::File,
        label: Formular::Elements::Bootstrap3::Label,
        textarea: Formular::Elements::Bootstrap3::Textarea,
        wrapper: Formular::Elements::Bootstrap3::Wrapper,
        submit: Formular::Elements::Bootstrap3::Submit
      }
    end #class Bootstrap3

    class Bootstrap3Inline < Formular::Builders::Basic
      self.elements = {
        form: Formular::Elements::Bootstrap3::Inline::Form,
        error: Formular::Elements::Bootstrap3::Error,
        input: Formular::Elements::Bootstrap3::Input,
        file: Formular::Elements::Bootstrap3::File,
        label: Formular::Elements::Bootstrap3::Label,
        textarea: Formular::Elements::Bootstrap3::Textarea,
        wrapper: Formular::Elements::Bootstrap3::Wrapper,
        submit: Formular::Elements::Bootstrap3::Submit
      }
    end #class Bootstrap3Inline

    class Bootstrap3Horizontal < Formular::Builders::Bootstrap3
      self.elements = {
        form: Formular::Elements::Bootstrap3::Horizontal::Form,
        error: Formular::Elements::Bootstrap3::Error,
        input: Formular::Elements::Bootstrap3::Horizontal::Input,
        file: Formular::Elements::Bootstrap3::Horizontal::File,
        label: Formular::Elements::Bootstrap3::Horizontal::Label,
        textarea: Formular::Elements::Bootstrap3::Horizontal::Textarea,
        wrapper: Formular::Elements::Bootstrap3::Wrapper,
        input_column_wrapper: Formular::Elements::Bootstrap3::Horizontal::InputColumnWrapper,
        submit: Formular::Elements::Bootstrap3::Horizontal::Submit
      }
      inheritable_attr :column_classes

      self.column_classes = {left_column: ["col-sm-2"], right_column: ["col-sm-10"], left_offset: ["col-sm-offset-2"]}
    end #class Bootstrap3Horizontal
  end #module Builders
end #module Formular
