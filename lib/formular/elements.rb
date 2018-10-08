require 'formular/element'
require 'formular/element/module'
require 'formular/element/modules/container'
require 'formular/element/modules/wrapped'
require 'formular/element/modules/control'
require 'formular/element/modules/checkable'
require 'formular/element/modules/error'
require 'formular/element/modules/escape_value'
require 'formular/html_escape'

module Formular
  class Element
    # These three are really just provided for convenience when creating other elements
    Container = Class.new(Formular::Element) { include Formular::Element::Modules::Container }
    Control = Class.new(Formular::Element) { include Formular::Element::Modules::Control }
    Wrapped = Class.new(Formular::Element) { include Formular::Element::Modules::Wrapped }

    # define some base classes to build from or easily use elsewhere
    Fieldset = Class.new(Container) { tag :fieldset }
    Legend = Class.new(Container) { tag :legend }
    Div = Class.new(Container) { tag :div }
    P = Class.new(Container) { tag :p }
    Span = Class.new(Container) { tag :span }
    Small = Class.new(Container) { tag :small }

    class OptGroup < Container
      include HtmlEscape
      tag :optgroup
      add_attribute_keys :disabled, :label
      process_option :label, :html_escape
    end

    class Option < Container
      tag :option
      add_attribute_keys :disabled, :value, :selected
      include Formular::Element::Modules::EscapeValue
    end

    class Form < Container
      tag :form
      add_attribute_keys :enctype, :method, :name, :novalidate, :target,
                         :accept, :action, :accept_charset, :autocomplete

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
        method = options[:method]

        case method
        when /^get$/ # must be case-insensitive, but can't use downcase as might be nil
          options[:method] = 'get'
          ''
        when /^post$/, '', nil
          options[:method] = 'post'
          ''
        else
          options[:method] = 'post'
          Hidden.(value: method, name: '_method').to_s
        end
      end
    end

    class ErrorNotification < Formular::Element
      tag :div

      html do |element|
        if element.builder_errors?
          concat start_tag
          concat element.error_message
          concat end_tag
        else
          ''
        end
      end

      def error_message
        options[:message] || 'Please review the problems below:'
      end

      def builder_errors?
        return false if builder.nil?
        !builder.errors.empty?
      end
    end

    class Error < P
      include Formular::Element::Modules::Error
      set_default :content, :error_text
    end # class Error

    class Textarea < Control
      include Formular::Element::Modules::Container
      tag :textarea
      add_attribute_keys :cols, :rows, :max_length, :min_length, :placeholder, :readonly, :wrap

      def content
        options[:value] || super
      end
    end # class Textarea

    class Label < Container
      tag :label
      add_attribute_keys :for
      set_default :for, :labeled_control_id

      # as per MDN A label element can have both a 'for' attribute and a contained control element,
      # as long as the for attribute points to the contained control element.
      def labeled_control_id
        return options[:labeled_control].options[:id] if options[:labeled_control]
        return builder.path(options[:attribute_name]).to_encoded_id if options[:attribute_name] && builder
      end
    end # class Label

    class Submit < Formular::Element
      include Formular::Element::Modules::EscapeValue
      add_attribute_keys :type, :value
      tag :input

      set_default :type, 'submit'

      html { closed_start_tag }
    end # class Submit

    class Button < Container
      include Formular::Element::Modules::EscapeValue
      add_attribute_keys :type, :autofocus, :disabled, :form, :name, :value
      tag :button
      set_default :type, 'button'
    end # class Button

    class Input < Control
      include Formular::Element::Modules::EscapeValue
      add_attribute_keys :type, :value, :placeholder, :readonly, :accept, :autocomplete,
                         :max, :min, :maxlength, :minlength, :mulitple

      tag :input
      set_default :type, 'text'

      html { closed_start_tag }
    end # class Input

    class Hidden < Input
      set_default :type, 'hidden'
    end

    class Select < Control
      include Formular::Element::Modules::Collection
      include HtmlEscape

      add_attribute_keys :multiple

      tag :select

      process_option :collection, :inject_placeholder
      process_option :name, :name_array_if_multiple

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
      # only append the [] to name if the multiple option is set
      def name_array_if_multiple(name)
        return unless name

        options[:multiple] ? "#{name}[]" : name
      end

      # same handling as simple form
      # prompt: a nil value option appears if we have no selected option
      # include blank: includes our nil value option regardless (useful for optional fields)
      def inject_placeholder(collection)
        placeholder = if options[:include_blank]
                        placeholder_option(options[:include_blank])
                      elsif options[:prompt] && options[:value].nil?
                        placeholder_option(options[:prompt])
                      end

        collection.unshift(placeholder) if placeholder

        collection
      end

      def placeholder_option(value)
        text = value.is_a?(String) ? html_escape(value) : ""
        [text, ""]
      end

      def collection_to_options(collection)
        collection.map do |item|
          if item.last.is_a?(Array)
            opts = { label: item.first, content: collection_to_options(item.last) }

            Formular::Element::OptGroup.new(opts).to_s
          else
            item_to_option(item)
          end
        end.join ''
      end

      def item_to_option(item)
        opts = if item.is_a?(Array) && item.size > 2
                 item.pop
               else
                 {}
               end

        opts[:value] = html_escape(item.send(options[:value_method]))
        opts[:content] = item.send(options[:label_method])

        opts[:selected] = 'selected' if item_is_selected(opts[:value], options[:value], options[:multiple])

        Formular::Element::Option.new(opts).to_s
      end

      def item_is_selected(option_val, current_val, multiple)
        return option_val == current_val.to_s unless multiple && current_val.is_a?(Array)

        current_val.map(&:to_s).include?(option_val) # TODO Perf improvement here - do we need the map?
      end
    end # class Select

    class Checkbox < Control
      tag :input

      set_default :type, 'checkbox'
      set_default :unchecked_value, :default_unchecked_value
      set_default :value, :default_checked_value # instead of reader value
      set_default :include_hidden, true

      include Formular::Element::Modules::Checkable

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

        Hidden.(value: options[:unchecked_value], name: options[:name]).to_s
      end

      private

      def default_checked_value
        return if collection?
        options[:checked_value] || '1'
      end

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

      include Formular::Element::Modules::Checkable

      html { closed_start_tag }
    end # class Radio
  end # class Element
end # module Formular
