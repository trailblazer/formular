require 'formular/element/module'
module Formular
  class Element
    module Modules
      # this module provides label options and methods to a control when included.
      module Label
        include Formular::Element::Module
        add_option_keys :label, :label_options

        # options functionality:
        # options[:label] == String return the string
        # currently we don't infer label text so if you don't include
        # label as an option, you wont get one rendered
        module InstanceMethods
          def label_text
            options[:label]
          end

          def has_label?
            !label_text.nil? && label_text != false
          end

          def label_options
            @label_options ||= Attributes[options[:label_options]]
          end
        end # module InstanceMethods
      end # module Label
    end # module Modules
  end # class Element
end # module Formular
