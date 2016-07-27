require 'formular/element/module'
require 'formular/element/modules/collection'
require 'formular/element/modules/label'

module Formular
  class Element
    module Modules
      # this module is used to correctly set the :checked attribute
      # based on the reader value.
      # It also provides an API to assist in generating checkable html (e.g. checkable labels)
      # and create collections of checkable controls from an enumerable variable.
      module Checkable
        include Formular::Element::Module
        include Collection
        include Label

        add_option_keys :control_label_options

        set_default :checked, 'checked', if: :is_checked?

        html(:checkable_label) do |input|
          Formular::Element::Label.(input.label_options) do
            if has_label?
              concat input.to_html(context: :default)
              concat " #{input.label_text}"
            else
              to_html(context: :default)
            end
          end
        end

        html(:collection) do |input|
          input.collection.map { |item|
            item.to_html(context: :checkable_label)
          }.join('')
        end

        module InstanceMethods
          def group_label
            return '' unless has_group_label?
            label_options[:content] = label_text
            builder.checkable_group_label(label_options).to_s
          end

          def has_group_label?
            collection.size > 1 && has_label?
          end

          def collection
            unless collection?
              options[:label_options] = options[:control_label_options]
              return [self]
            end

            base_options = collection_base_options

            @collection ||= options[:collection].map do |item|
              opts = base_options.dup
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
  end # class Element
end # module Formular
