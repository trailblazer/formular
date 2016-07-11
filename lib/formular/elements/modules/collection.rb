require 'formular/elements/module'
module Formular
  module Elements
    module Modules
      # this module is used to correctly set the :checked attribute
      # based on the reader value
      module Collection
        include Formular::Elements::Module

        add_option_keys :collection, :label_method, :value_method

        set_default :label_method, 'last'
        set_default :value_method, 'first'
      end
    end
  end
end