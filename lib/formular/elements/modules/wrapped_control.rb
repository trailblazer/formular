require "formular/elements/module"
require "formular/elements/modules/control"
module Formular
  module Elements
    module Modules
      #include this module to enable an element to render the entire wrapped input
      #e.g. wrapper{label+control+error_messages}
      #TODO::
      #  enable hints
      module WrappedControl
        include Formular::Elements::Module
        include Formular::Elements::Modules::Control

        add_option_keys [:error_options, :label_options, :wrapper_options, :label]
        set_default :error, :error_message

        html do |input|
          input.wrapper do
            concat input.label
            concat input.control_html
            concat input.error
          end.to_s
        end

        module InstanceMethods
          def wrapper(&block)
            wrapper_element = options[:error] ? :error_wrapper : :wrapper
            builder.send(wrapper_element, Attributes[options[:wrapper_options]], &block)
          end

          def label
            return "" unless options[:label]
            label_opts = Attributes[options[:label_options]].merge({ content: options[:label], labeled_control: self})
            builder.label(label_opts).to_s
          end

          def error
            return "" unless has_errors?
            error_opts = Attributes[options[:error_options]].merge({ content: options[:error] })
            builder.error(error_opts).to_s
          end
        end #module InstanceMethods
      end #module WrappedControl
    end #module Modules
  end #module Elements
end #module Formular
