require 'formular/elements/module'
module Formular
  module Elements
    module Modules
      # this module is used to correctly set the :checked attribute
      # based on the reader value
      module Checkable
        include Formular::Elements::Module
        include Control

        set_default :value, nil # instead of reader value
        set_default :checked, 'checked', if: :is_checked?

        def is_checked?
          !options[:checked].nil? || reader_value == attributes[:value]
        end
      end

      # this module is used for generating groups of
      # radios or checkbox controls from an array.
      module Checkable::Group
        include Formular::Elements::Module


        # we need to accept an array of options e.g. [["Option 1", 1], ["Option 2", 2]]
        # and convert into an array of controls,
      end # module Checkable::Group
    end # module Modules
  end # module Elements
end # module Formular
