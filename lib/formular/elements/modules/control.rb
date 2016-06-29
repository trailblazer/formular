require 'formular/elements/module'
module Formular
  module Elements
    module Modules
      # include this module in an element to set the id, name &value based on the attribute name
      module Control
        include Formular::Elements::Module

        add_option_keys [:attribute_name]

        set_default :name, :form_encoded_name
        set_default :id, :form_encoded_id
        set_default :value, :reader_value

        module InstanceMethods
          def attribute_name
            options[:attribute_name]
          end

          private
          def path
            @path ||= builder.path(attribute_name) if attribute_name && builder
          end

          def form_encoded_name
            path.to_encoded_name if path
          end

          def form_encoded_id
            path.to_encoded_id if path
          end

          def reader_value
            builder.reader_value(attribute_name) if attribute_name && builder
          end
        end # model InstanceMethods
      end # module Control
    end # module Modules
  end # module Elements
end # module Formular
