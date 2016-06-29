require 'formular/elements/module'
module Formular
  module Elements
    module Modules
      # this module provides label to a control when included.
      module Labels
        include Formular::Elements::Module
        add_option_keys [:label, :label_options]

        # options functionality (same as SimpleForm):
        # options[:hint] == String return the string
        module InstanceMethods
          def label_text
            options[:label]
          end

          def has_label?
            label_text.is_a?(String)
          end

          private
          def label_options
            @label_options ||= Attributes[options[:label_options]]
          end
        end # module InstanceMethods
      end # module Labels
    end # module Modules
  end # module Elements
end # module Formular
