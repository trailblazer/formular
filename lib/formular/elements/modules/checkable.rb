require 'formular/elements/module'
module Formular
  module Elements
    module Modules
      # this module is used to correctly set the :checked attribute
      # based on the reader value
      module Checkable
        include Formular::Elements::Module
        include Control

        add_option_keys [:collection]

        set_default :value, nil # instead of reader value
        set_default :checked, 'checked', if: :is_checked?

        module InstanceMethods
          def is_checked?
            !options[:checked].nil? || reader_value == attributes[:value]
          end

          def checkable_label
            label_opts = Attributes[options[:label_options]]
            label_opts[:content] = options[:label] ? "#{control_html} #{options[:label]}" : control_html.to_s
            Formular::Elements::Label.(label_opts).to_s
          end

          def controls_collection
            return [self] unless options[:collection]

            options[:collection].map do |array|
              value, label = array
              name = attribute_name ? "#{attribute_name}_#{value}" : value
              self.class.(id: name, name: name, label: label, value: value)
            end
          end
        end
      end
    end # module Modules
  end # module Elements
end # module Formular
