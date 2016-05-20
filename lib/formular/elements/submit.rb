require "formular/elements/input"
module Formular
  module Elements
    class Submit < Formular::Elements::Input
      tag "input"

      attribute :type, "submit"

      #when we can inherit from Input lets inherit this...
      html { opening_tag(true) }
    end
  end
end
