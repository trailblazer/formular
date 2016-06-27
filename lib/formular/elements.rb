require 'formular/element'
require 'formular/elements/module'
require 'formular/elements/modules/container'
require 'formular/elements/modules/wrapped_control'
require 'formular/elements/modules/control'
require 'formular/elements/modules/checkable'
require 'formular/elements/modules/errors'

module Formular
  module Elements
    # These three are really just provided for convenience when creating other elements
    Container = Class.new(Formular::Element) { include Formular::Elements::Modules::Container }
    Control = Class.new(Formular::Element) { include Formular::Elements::Modules::Control }
    Checkable = Class.new(Formular::Element) { include Formular::Elements::Modules::Checkable }
    WrappedControl = Class.new(Formular::Element) { include Formular::Elements::Modules::WrappedControl }

    Option = Class.new(Container)
    OptGroup = Class.new(Container)
    Fieldset = Class.new(Container)
    Legend = Class.new(Container)
    Div = Class.new(Container)
    Form = Class.new(Container) { set_default :method, "post" }

    class Error < Container
      include Formular::Elements::Modules::Errors

      tag 'p'
      add_option_keys [:attribute_name]
      set_default :content, :error_message
    end # class Error

    class Textarea < Control
      include Formular::Elements::Modules::Container
      add_option_keys [:value]

      def content
        options[:value] || super
      end
    end # class Textarea

    class Label < Container
      add_option_keys [:labeled_control]
      set_default :for, :labeled_control_id

      # as per MDN A label element can have both a 'for' attribute and a contained control element,
      # as long as the for attribute points to the contained control element.
      def labeled_control_id
        return nil unless options[:labeled_control]
        options[:labeled_control].attributes[:id]
      end
    end # class Label

    class Submit < Formular::Element
      tag 'input'

      set_default :type, 'submit'

      html { closed_start_tag }
    end # class Submit

    class Input < Control
      set_default :type, 'text'
      html { closed_start_tag }
    end # class Input

    class Select < Control
      add_option_keys [:collection, :value]

      html do |input|
        concat start_tag
        concat input.option_tags
        concat end_tag
      end

      # convert the collection array into option tags also supports option groups
      # when the array is nested
      # example 1:
      # [[1,"True"], [0,"False"]] =>
      # <option value="1">true</option><option value="0">false</option>
      # example 2:
      # [
      #   ["Genders", [["m", "Male"], ["f", "Female"]]],
      #   ["Booleans", [[1,"true"], [0,"false"]]]
      # ] =>
      # <optgroup label="Genders">
      #  <option value="m">Male</option>
      #  <option value="f">Female</option>
      # </optgroup>
      # <optgroup label="Booleans">
      #   <option value="1">true</option>
      #   <option value="0">false</option>
      # </optgroup>
      def option_tags
        collection_to_options(options[:collection])
      end

      def collection_to_options(collection)
        collection.map do |array|
          if array.last.is_a?(Array)
            opts = {label: array.first, content: collection_to_options(array.last)}
            # we should probably call this through the builder incase people need to edit it?
            Formular::Elements::OptGroup.new(opts).to_s
          else
            array_to_option(array)
          end
        end.join ''
      end

      def array_to_option(array)
        opts = {value: array.first, content: array.last}
        opts[:selected] = 'selected' if array.first == options[:value]
        # we should probably call this through the builder incase people need to edit it?
        Formular::Elements::Option.new(opts).to_s
      end
    end # class Select

    class Checkbox < Checkable
      tag 'input'
      set_default :type, 'checkbox'

      html { closed_start_tag }

      def form_encoded_name
        builder.path(attribute_name).to_encoded_name + '[]' if attribute_name && builder
      end
    end # class Checkbox

    class Radio < Checkable
      tag 'input'
      set_default :type, 'radio'

      html { closed_start_tag }
    end # class Radio
  end # module Elements
end # module Formular
