require 'formular/builders/bootstrap3'
require 'formular/elements/bootstrap3/inline'
module Formular
  module Builders
    class Bootstrap3Inline < Formular::Builders::Bootstrap3
      element_set form: Formular::Elements::Bootstrap3::Inline::Form
    end # class Bootstrap3Inline
  end # module Builders
end # module Formular
