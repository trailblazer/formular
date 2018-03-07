require 'formular/element/module'
module Formular
  class Element
    module Modules
      # This module adds the relevant option keys and defaults
      # for elements that support collections
      module Collection
        include Formular::Element::Module

        set_default :label_method, 'first'
        set_default :value_method, 'last'
      end
    end
  end
end