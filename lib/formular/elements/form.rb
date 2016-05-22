require "formular/elements/container"
module Formular
  module Elements
    class Form < Formular::Elements::Container
      attribute :method, "post"
    end # class Form
  end #module Elements
end #module Formular
