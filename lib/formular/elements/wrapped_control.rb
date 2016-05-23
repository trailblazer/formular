require "formular/elements/module"
module Formular
  module Elements
    #include this module to enable an element to render the entire wrapped input
    #e.g. label+control+error_messages
    #TODO::
    #  enable hints
    module WrappedControl
      include Formular::Elements::Module
      add_option_keys [:error_options, :label_options, :wrapper_options, :label, :error]

      html do |input|
        input.wrapper do
          concat input.label
          concat input.control_html
          concat input.error
        end.to_s
      end

      module InstanceMethods
        def wrapper(&block)
          wrapper_element = builder.has_errors?(options[:attribute_name]) ? :error_wrapper : :wrapper
          builder.send(wrapper_element, options[:wrapper_options], &block)
        end

        def label
          wrapped_element(:label)
        end

        def error
          wrapped_element(:error)
        end

        private
        def wrapped_element(element)
          return "" if options[element] == false
          element_opts = wrapped_element_options(options[element], options["#{element}_options".to_sym])
          builder.send(element, options[:attribute_name], element_opts).to_s
        end

        def wrapped_element_options(element_label, element_options)
          opts = element_options || {}
          element_label.is_a?(String) ? opts.merge({ content: element_label }) : opts
        end
      end #module InstanceMethods
    end #module WrappedControl
  end #module Elements
end #module Formular
