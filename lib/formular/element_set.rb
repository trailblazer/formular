require "formular/element"

module Formular
  class ElementSet
    #where elements is a hash with the name as the key and the class as the value e.g.
    #{
    # file: Formular::Bootstrap3::File
    # label: Formular::Elements::Label
    #}

    attr_reader :elements
    def initialize(elements)
      @elements = elements
    end

    def [](name)
      @elements[name]
    end
  end #class ElementSet
end #module Formular
