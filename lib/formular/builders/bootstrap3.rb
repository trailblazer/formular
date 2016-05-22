require "formular/builders/basic"
require "formular/elements/bootstrap3"
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
    end #module Bootstrap3
  end #module Builders
end #module Formular
