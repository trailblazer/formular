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
    class Hidden < Control
      tag :input
      set_default :type, 'hidden'

      html { closed_start_tag }
    end

    class Form < Container
      add_option_keys :enforce_utf8, :csrf_token, :csrf_token_name

      set_default :method, 'post'
      set_default :accept_charset, 'utf-8'
      set_default :enforce_utf8, true

      html do |element|
        if element.has_content?
          element.to_html(context: :with_content)
        else
          hidden_tags = element.extra_hidden_tags
          start_tag + hidden_tags
        end
      end

      def content
        extra_hidden_tags + super
      end

      def extra_hidden_tags
        token_tag + utf8_enforcer_tag + method_tag
      end

      private

      def token_tag
        return '' unless options[:csrf_token].is_a? String

        name = options[:csrf_token_name] || '_csrf_token'

        Hidden.(value: options[:csrf_token], name: name).to_s
      end

      def utf8_enforcer_tag
        return '' unless options[:enforce_utf8]

        # Use raw HTML to ensure the value is written as an HTML entity; it
        # needs to be the right character regardless of which encoding the
        # browser infers.
        %(<input name="utf8" type="hidden" value="✓"/>)
      end

      # because this mutates attributes, we have to call this before rendering the start_tag
      def method_tag
        method = attributes[:method]

        case method
        when /^get$/ # must be case-insensitive, but can't use downcase as might be nil
          attributes[:method] = 'get'
          ''
        when /^post$/, '', nil
          attributes[:method] = 'post'
          ''
        else
          attributes[:method] = 'post'
          Hidden.(value: method, name: '_method').to_s
        end
      end
    end

    class Error < Container
      include Formular::Elements::Modules::Errors

      tag :p
      add_option_keys :attribute_name
      set_default :content, :error_text
    end # class Error

    class Hint < Container
      tag :p
    end # class Hint

    class Textarea < Control
      include Formular::Elements::Modules::Container
      add_option_keys :value

      # we should always render complete element tags
      # we don't want opens without closes for textareas
      html do |element|
        element.to_html(context: :with_content)
      end

      def content
        options[:value] || super
      end
    end # class Textarea

    class Label < Container
      add_option_keys :labeled_control, :attribute_name
      set_default :for, :labeled_control_id

      # as per MDN A label element can have both a 'for' attribute and a contained control element,
      # as long as the for attribute points to the contained control element.
      def labeled_control_id
        return options[:labeled_control].attributes[:id] if options[:labeled_control]
        return builder.path(options[:attribute_name]).to_encoded_id if options[:attribute_name] && builder
      end
    end # class Label

    class Submit < Formular::Element
      tag :input

      set_default :type, 'submit'

      html { closed_start_tag }
    end # class Submit

    class Button < Formular::Elements::Container
      add_option_keys :value

      html do |element|
        element.to_html(context: :with_content)
      end

      def content
        options[:value] || super
      end
    end # class Button

    class Input < Control
      set_default :type, 'text'
      html { closed_start_tag }
    end # class Input

    class Select < Control
      include Formular::Elements::Modules::Collection

      add_option_keys :value

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

      private

      def collection_to_options(collection)
        collection.map do |item|
          if item.last.is_a?(Array)
            opts = { label: item.first, content: collection_to_options(item.last) }

            Formular::Elements::OptGroup.new(opts).to_s
          else
            item_to_option(item)
          end
        end.join ''
      end

      def item_to_option(item)
        value = item.send(options[:value_method])
        label = item.send(options[:label_method])

        opts = { value: value, content: label }
        opts[:selected] = 'selected' if value == options[:value]

        Formular::Elements::Option.new(opts).to_s
      end
    end # class Select

    class Checkbox < Checkable
      add_option_keys :unchecked_value, :include_hidden, :multiple

      tag :input
      set_default :type, 'checkbox'
      set_default :unchecked_value, :default_unchecked_value
      set_default :value, '1' # instead of reader value

      set_default :include_hidden, true

      html do |element|
        if element.collection?
          element.to_html(context: :with_collection)
        else
          concat element.hidden_tag
          concat closed_start_tag
        end
      end

      html(:with_collection) do |element|
        concat element.collection.map(&:checkable_label).join('')
        concat element.hidden_tag
      end

      def hidden_tag
        return '' unless options[:include_hidden]

        Hidden.(value: options[:unchecked_value], name: attributes[:name]).to_s
      end

      private

      def default_unchecked_value
        options[:collection] ? '' : '0'
      end

      # only append the [] to name if part of a collection, or the multiple option is set
      def form_encoded_name
        return unless path

        options[:multiple] || options[:collection] ? super + '[]' : super
      end

      def collection_base_options
        super.merge(include_hidden: false)
      end
    end # class Checkbox

    class Radio < Checkable
      tag :input
      set_default :type, 'radio'
      set_default :value, nil # instead of reader value

      html { closed_start_tag }
    end # class Radio
  end # module Elements
end # module Formular
