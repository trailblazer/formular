require 'formular/builders/bootstrap3'
module Formular
  module Builders
    class Bootstrap3Inline < Formular::Builders::Bootstrap3
      Form = Class.new(Formular::Element::Form) { set_default :class, ['form-inline'] }

      element_set form: Form
    end # class Bootstrap3Inline
  end # module Builders
end # module Formular
