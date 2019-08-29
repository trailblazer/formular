require 'formular/element/module'
require 'formular/element/modules/escape_value'
module Formular
  class Element
    module Modules
      # include this module in an element to set the id,
      # name & value based on the attribute name
      module Control
        include Formular::Element::Module
        add_attribute_keys :disabled, :form, :name, :required, :autofocus

        set_default :name, :form_encoded_name
        set_default :id, :form_encoded_id
        set_default :value, :reader_value

        module InstanceMethods
          def attribute_name
            options[:attribute_name]
          end

          private

          # FIXME... we should probably find a better way of returning nil to all of these if
          # no attribute_name or builder
          def builder_attribute?
            attribute_name && builder
          end

          def path
            @path ||= builder.path(attribute_name) if builder_attribute?
          end

          def form_encoded_name
            path.to_encoded_name if builder_attribute?
          end

          def form_encoded_id
            path.to_encoded_id if builder_attribute?
          end

          def reader_value
            builder.reader_value(attribute_name) if builder_attribute?
          end

          def translation_key
            builder.translation_key(attribute_name) if builder_attribute?
          end
        end # model InstanceMethods
      end # module Control
    end # module Modules
  end # class Element
end # module Formular
