require 'formular/builders/bootstrap4'
require 'formular/builders/bootstrap3_inline'
require 'formular/element/bootstrap4/custom_control'

module Formular
  module Builders
    class Bootstrap4Inline < Formular::Builders::Bootstrap4
      element_set(
        form: Bootstrap3Inline::Form,
        custom_select: Formular::Element::Bootstrap4::CustomControl::Inline::CustomSelect,
        custom_file: Formular::Element::Bootstrap4::CustomControl::Inline::CustomFile
      )
    end # class Bootstrap4Inline
  end # module Builders
end # module Formular
