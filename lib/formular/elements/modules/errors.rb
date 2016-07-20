require 'formular/elements/module'
module Formular
  module Elements
    module Modules
      # this module provides error methods and options to a control when included
      module Errors
        include Formular::Elements::Module
        add_option_keys :error

        # options functionality (same as SimpleForm):
        # options[:error] == false NO ERROR regardless of model errors
        # options[:error] == String return the string, regardless of model errors
        module InstanceMethods
          def error_text
            has_custom_error? ? options[:error] : errors_on_attribute.send(error_method) if has_errors?
          end

          def has_errors?
            options[:error] != false && (has_custom_error? || has_attribute_errors?)
          end

          protected

          # attribute_errors is an array, what method should we use to return a
          # string? (:first, :last, :join etc.)
          # ideally this should be configurable via the builder...
          def error_method
            :first
          end

          # I bet we could clean this up alot but it needs to be flexible
          # enough not to error with nils
          def has_attribute_errors?
            builder != nil && builder.errors != nil && errors_on_attribute != nil && errors_on_attribute.size > 0
          end

          def has_custom_error?
            options[:error].is_a?(String)
          end

          def errors_on_attribute
            @errors ||= builder.errors[options[:attribute_name]]
          end
        end # module InstanceMethods
      end # module Errors
    end # module Modules
  end # module Elements
end # module Formular
