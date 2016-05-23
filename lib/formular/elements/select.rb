require "formular/element"
require "formular/elements/container"
module Formular
  module Elements
    class Select < Formular::Element
      add_option_keys [:collection, :value, :attribute_name]

      html do |input|
        concat opening_tag
        concat input.option_tags
        concat closing_tag
      end

      #convert the collection array into option tags also supports option groups
      #when the array is nested
      #[[1,"True"], [0,"False"]] => <option value="1">true</option><option value="0">false</option>
      #[["Genders", [["m", "Male"], ["f", "Female"]]], ["Booleans", [[1,"true"], [0,"false"]]]] =><optgroup label="Genders"><option value="m">Male</option><option value="f">Female</option></optgroup><optgroup label="Booleans"><option value="1">true</option><option value="0">false</option></optgroup>
      def option_tags
        collection_to_options(options[:collection])
      end

      def collection_to_options(collection)
        collection.map do |array|
          if array.last.is_a?(Array)
            opts = {label: array.first, content: collection_to_options(array.last)}
            Formular::Elements::OptGroup.new(opts).to_s #we should probably call this through the builder incase people need to edit it?
          else
            array_to_option(array)
          end
        end.join ""
      end

      def array_to_option(array)
        opts = {value: array.first, content: array.last}
        opts[:selected] = "selected" if array.first == options[:value]
        Formular::Elements::Option.new(opts).to_s #we should probably call this through the builder incase people need to edit it?
      end
    end # class Select
    OptGroup = Class.new(Formular::Elements::Container)
    Option = Class.new(Formular::Elements::Container)
  end #module Elements
end #module Formular
