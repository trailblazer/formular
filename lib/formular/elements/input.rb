require "formular/element"
module Formular
  module Elements
    class Input < Formular::Element
      html { opening_tag(true) }
    end # class Input
  end #module Elements
end #module Formular
