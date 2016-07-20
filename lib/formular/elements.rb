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
    WrappedControl = Class.new(Formular::Element) { include Formular::Elements::Modules::WrappedControl }

    # define some base classes to build from or easily use elsewhere
    Option = Class.new(Container) { tag :option }
    OptGroup = Class.new(Container) { tag :optgroup }
    Fieldset = Class.new(Container) { tag :fieldset }
    Legend = Class.new(Container) { tag :legend }
    Div = Class.new(Container) { tag :div }
    P = Class.new(Container) { tag :p }
    Span = Class.new(Container) { tag :span }

    class Hidden < Control
      tag :input
      set_default :type, 'hidden'

      html { closed_start_tag }
    end

    class Form < Container
      tag :form

      add_option_keys :enforce_utf8, :csrf_token, :csrf_token_name

      set_default :method, 'post'
      set_default :accept_charset, 'utf-8'
      set_default :enforce_utf8, true

      html(:start) do |form|
        hidden_tags = element.extra_hidden_tags
        concat start_tag
        concat hidden_tags
      end

      html do |form|
        concat form.to_html(context: :start)
        concat form.content
        concat end_tag
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

    class Error < P
      include Formular::Elements::Modules::Errors
      add_option_keys :attribute_name
      set_default :content, :error_text
    end # class Error

    class Textarea < Control
      include Formular::Elements::Modules::Container
      tag :textarea
      add_option_keys :value

      def content
        options[:value] || super
      end
    end # class Textarea

    class Label < Container
      tag :label
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
      tag :button
      add_option_keys :value

      def content
        options[:value] || super
      end
    end # class Button

    class Input < Control
      tag :input
      set_default :type, 'text'
      html { closed_start_tag }
    end # class Input

    class Select < Control
      include Formular::Elements::Modules::Collection
      tag :select

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

    class Checkbox < Control
      tag :input

      add_option_keys :unchecked_value, :include_hidden, :multiple

      set_default :type, 'checkbox'
      set_default :unchecked_value, :default_unchecked_value
      set_default :value, '1' # instead of reader value
      set_default :include_hidden, true

      include Formular::Elements::Modules::Checkable

      html do |element|
        if element.collection?
          element.to_html(context: :with_collection)
        else
          concat element.hidden_tag
          concat closed_start_tag
        end
      end

      html(:with_collection) do |element|
        concat element.to_html(context: :collection)
        concat element.hidden_tag
      end

      def hidden_tag
        return '' unless options[:include_hidden]

        Hidden.(value: options[:unchecked_value], name: attributes[:name]).to_s
      end

      private

      def default_unchecked_value
        collection? ? '' : '0'
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

    class Radio < Control
      tag :input

      set_default :type, 'radio'
      set_default :value, nil # instead of reader value

      include Formular::Elements::Modules::Checkable

      html { closed_start_tag }
    end # class Radio
  end # module Elements
end # module Formular
