require 'formular/elements/module'
require 'formular/elements/modules/control'
require 'formular/elements/modules/collection'
require 'formular/elements/modules/labels'

module Formular
  module Elements
    module Modules
      # this module is used to correctly set the :checked attribute
      # based on the reader value
      module Checkable
        include Formular::Elements::Module
        include Control
        include Collection
        include Labels

        add_option_keys :control_label_options, :label_options, :label

        set_default :checked, 'checked', if: :is_checked?

        module InstanceMethods
          def checkable_label
            label_options[:content] = if has_label?
                                        "#{to_html(context: :default)} #{label_text}"
                                      else
                                        to_html(context: :default).to_s
                                      end

            Formular::Elements::Label.(label_options).to_s
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
            unless collection?
              options[:label_options] = options[:control_label_options]
              return [self]
            end

            base_options = collection_base_options

            @collection ||= options[:collection].map do |item|
              opts = collection_base_options.dup
              opts[:value] = item.send(options[:value_method])
              opts[:label] = item.send(options[:label_method])

              opts[:id] = if attributes[:id]
                            "#{attributes[:id]}_#{opts[:value]}"
                          else
                            "#{attribute_name || attributes[:name].gsub('[]', '')}_#{opts[:value]}"
                          end

              self.class.(opts)
            end
          end

          def collection?
            options[:collection]
          end

          private

          # we can't access other defaults
          def is_checked?
            !options[:checked].nil? || reader_value == attributes[:value]
          end

          def collection_base_options
            opts = attributes.select { |k, v| ![:name, :id, :checked].include?(k) }
            opts[:attribute_name] = attribute_name if attribute_name
            opts[:builder]        = builder if builder
            opts[:label_options]  = options[:control_label_options] if options[:control_label_options]
            opts[:name]           = attributes[:name] if attributes[:name]

            opts
          end
        end
      end
    end # module Modules
  end # module Elements
end # module Formular
