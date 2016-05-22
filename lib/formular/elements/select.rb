require "formular/element"
module Formular
  module Elements
    module Controls
      class Select < Formular::Element
        html do
          concat opening_tag
          concat options
          concat closing_tag
        end

        #[[1,"true"], [0,"false"]] => <option value="1">true</option><option value="0">false</option>
        #[["Genders", ["m", "Male"], ["f", "Female"]], ["Booleans", [[1,"true"], [0,"false"]]]] =><optgroup label="Genders"><option value="m">Male</option><option value="f">Female</option></optgroup><optgroup label="Booleans"><option value="1">true</option><option value="0">false</option></optgroup>
        def options
          @options[:collection] #convert to option tags/ option groups
          #convert the collection of options into option tags
          #need to get value somehow... (attributes.delete(:value))???
        end
      end # class Select
    end #module Controls
  end #module Elements
end #module Formular
