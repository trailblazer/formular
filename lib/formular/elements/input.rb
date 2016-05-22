require "formular/element"
module Formular
  module Elements
    class Input < Formular::Element
      attribute :type, "text"

      html { opening_tag(true) }

      #need to ensure that this ignors labels... ?
      # def encoded_name
     #    options[:container] ? "#{container.path}[#{attribute[:name]}]" : attribute[:name]
     #  end
    end # class Input
  end #module Elements
end #module Formular
