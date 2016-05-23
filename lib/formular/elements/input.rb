require "formular/element"
module Formular
  module Elements
    class Input < Formular::Element
      attribute :type, "text"
      add_option_keys [:attribute_name]
      html { opening_tag(true) }
    end # class Input
  end #module Elements
end #module Formular
