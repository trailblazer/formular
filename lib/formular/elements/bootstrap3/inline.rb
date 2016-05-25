require "formular/elements"
require "formular/elements/bootstrap3"
module Formular
  module Elements
    module Bootstrap3
      module Inline
        Form = Class.new(Formular::Elements::Form) { set_default :class, ["form-inline"] }
      end #module Inline
    end #module Bootstrap3
  end #module Elements
end #module Formular
