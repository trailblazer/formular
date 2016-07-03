require 'formular/elements/module'
module Formular
  module Elements
    module Modules
      # this module is used to correctly set the :checked attribute
      # based on the reader value
      module Checkable
        include Formular::Elements::Module
        include Control

        add_option_keys :collection, :control_label_options

        set_default :value, nil # instead of reader value
        set_default :checked, 'checked', if: :is_checked?

        module InstanceMethods
          def is_checked?
            !options[:checked].nil? || reader_value == attributes[:value]
          end

          def checkable_label
            label_opts = Attributes[options[:label_options]]
            label_opts[:content] = if options[:label]
                                     "#{to_html(context: :default)} #{options[:label]}"
                                   else
                                     to_html(context: :default).to_s
                                   end
            Formular::Elements::Label.(label_opts).to_s
          end

          def group_label
            return '' unless has_group_label?
            label_opts = Attributes[options[:label_options]]
            label_opts[:content] = options[:label]
            builder.checkable_group_label(label_opts).to_s
          end

          def has_group_label?
            collection.size > 1 && !options[:label].nil?
          end

          def collection
            unless options[:collection]
              options[:label_options] = options[:control_label_options]
              return [self]
            end

            @collection ||= options[:collection].map do |array|
              el_value, el_label = array
              id = attributes[:id] ? "#{attributes[:id]}_#{el_value}" : "#{attribute_name || attributes[:name]}_#{el_value}"

              opts = attributes.select{ |k, v| ![:name, :id, :checked].include?(k) }.merge(
                id: id,
                attribute_name: attribute_name,
                builder: builder,
                label: el_label,
                value: el_value,
                label_options: options[:control_label_options]
              )
              self.class.(opts)
            end
          end
        end
      end
    end # module Modules
  end # module Elements
end # module Formular
