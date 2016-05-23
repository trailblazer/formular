module Formular
  module Elements
    #include this module to enable an element to render the entire wrapped input
    #e.g. label+control+error_messages
    #TODO::
    #  make label optional (add label option_key) use as content or don't render label if false
    #  Enable element class methods in module
    module WrappedControl
      module InstanceMethods
        def wrapper(&block)
          wrapper_element = builder.has_errors?(options[:attribute_name]) ? :error_wrapper : :wrapper
          builder.send(wrapper_element, options[:wrapper_options], &block)
        end

        def label
          builder.label(options[:attribute_name], options[:label_options]).to_s
        end

        def error
          builder.error(options[:attribute_name], options[:error_options]).to_s
        end
      end #module InstanceMethods

      module ClassMethods
        #I want to be able to declare this here & have it extend classes.
        #Instead I'm having to add this line into each class.
        #self.option_keys += [:error_options, :label_options, :wrapper_options]

        #would rather be able to declare the html block here
        #html { ... }
        #currently each extended class has to write html &html_block
        def html_block
          Proc.new() do |input|
            input.wrapper do
              concat input.label
              concat input.control_html
              concat input.error
            end.to_s
          end
        end
      end #module ClassMethods
    end #module WrappedControl
  end #module Elements
end #module Formular
