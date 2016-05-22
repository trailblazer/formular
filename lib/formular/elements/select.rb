require "formular/element"
require "formular/elements/container"
module Formular
  module Elements
    class Select < Formular::Element
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
            attrs = {label: array.first}
            opts = {content: collection_to_options(array.last)}
            Formular::Elements::OptGroup.new(attrs, opts).to_s #we should probably call this through the builder incase people need to edit it?
          else
            array_to_option(array)
          end
        end.join ""
      end

      def array_to_option(array)
        attrs = {value: array.first}
        attrs[:selected] = "selected" if array.first == options[:value]
        opts = {content: array.last}
        Formular::Elements::Option.new(attrs, opts).to_s #we should probably call this through the builder incase people need to edit it?
      end
    end # class Select

    class OptGroup < Formular::Elements::Container

    end #class OptionGroup

    class Option < Formular::Elements::Container

    end #class Option
  end #module Elements
end #module Formular
