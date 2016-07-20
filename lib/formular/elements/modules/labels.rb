require 'formular/elements/module'
module Formular
  module Elements
    module Modules
      # this module provides label options and methods to a control when included.
      module Labels
        include Formular::Elements::Module
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
      end # module Labels
    end # module Modules
  end # module Elements
end # module Formular
