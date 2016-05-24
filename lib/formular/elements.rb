require "formular/element"
require "formular/elements/module"
require "formular/elements/modules/container"
require "formular/elements/modules/control"

module Formular
  module Elements
    Container = Class.new(Formular::Element) { include Formular::Elements::Modules::Container }
    Option = Class.new(Container)
    OptGroup = Class.new(Container)
    Fieldset = Class.new(Container)
    Form = Class.new(Container) { attribute :method, "post" }

    class Error < Container
      tag "p"
      add_option_keys [:attribute_name]
      attribute :content, :error_message


      def error_message
        (options[:attribute_name] && builder) ? builder.error_message(options[:attribute_name]) : nil
      end
    end #class Error

    class Textarea < Container
      add_option_keys [:value]
      include Formular::Elements::Modules::Control

      def content
        options[:value] || super
      end
    end #class Textarea

    class Label < Container
      add_option_keys [:labeled_control]
      attribute :for, :labeled_control_id

      #as per MDN A label element can have both a for attribute and a contained control element,
      #as long as the for attribute points to the contained control element.
      def labeled_control_id
        return nil unless options[:labeled_control]
        options[:labeled_control].attributes[:id]
      end
    end #class Label

    class Submit < Formular::Element
      tag "input"

      attribute :type, "submit"

      html { opening_tag(true) }
    end #class Submit

    class Input < Formular::Element
      include Formular::Elements::Modules::Control
      attribute :type, "text"
      html { opening_tag(true) }
    end # class Input

    class Select < Formular::Element
      include Formular::Elements::Modules::Control
      add_option_keys [:collection, :value]

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
  end #module Elements
end #module Formular
