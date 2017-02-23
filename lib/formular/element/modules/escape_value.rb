require 'formular/element/module'
require 'formular/html_escape'
module Formular
  class Element
    module Modules
      # include this module in an element to automatically escape the html of the value attribute
      module EscapeValue
        include Formular::Element::Module
        include HtmlEscape
        process_option :value, :html_escape
      end # module EscapeValue
    end # module Modules
  end # class Element
end # module Formular
