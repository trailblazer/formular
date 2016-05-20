require "formular/element"
module Formular
  module Elements
    module Controls
      class Select < Formular::Element

        def initialize(attributes = {})
          @options = options_from_array(options)

          super(attributes)
        end

        html do |output|
          output << opening_tag
          output << options
          output << closing_tag
        end

        #[[1,"true"], [0,"false"]] => <option value="1">true</option><option value="0">false</option>
        #[["Genders", ["m", "Male"], ["f", "Female"]], ["Booleans", [[1,"true"], [0,"false"]]]] =><optgroup label="Genders"><option value="m">Male</option><option value="f">Female</option></optgroup><optgroup label="Booleans"><option value="1">true</option><option value="0">false</option></optgroup>
        def options(array)
          #convert the collection of options into option tags
          #handling #value correctly.
        end
      end # class Select
    end #module Controls
  end #module Elements
end #module Formular
