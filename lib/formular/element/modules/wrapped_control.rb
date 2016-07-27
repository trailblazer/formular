require 'formular/element/module'
require 'formular/element/modules/control'
require 'formular/element/modules/hint'
require 'formular/element/modules/error'
require 'formular/element/modules/label'
module Formular
  class Element
    module Modules
      # include this module to enable an element to render the entire wrapped input
      # e.g. wrapper{label+control+hint+error}
      module WrappedControl
        include Formular::Element::Module
        include Control
        include Hint
        include Error
        include Label

        add_option_keys :error_options, :wrapper_options
        set_default :aria_describedby, :hint_id, if: :has_hint?

        self.html_context = :wrapped

        html(:wrapped) do |input|
          input.wrapper do
            concat input.label
            concat input.to_html(context: :default)
            concat input.hint
            concat input.error
          end
        end

        module InstanceMethods
          def wrapper(&block)
            wrapper_element = has_errors? ? :error_wrapper : :wrapper
            builder.send(wrapper_element, Attributes[options[:wrapper_options]], &block)
          end

          def label
            return '' unless has_label?

            label_options[:content] = label_text
            label_options[:labeled_control] = self
            builder.label(label_options).to_s
          end

          def error
            return '' unless has_errors?

            error_options[:content] = error_text
            builder.error(error_options).to_s
          end

          def hint
            return '' unless has_hint?

            hint_options[:content] = hint_text
            hint_options[:id] ||= hint_id
            builder.hint(hint_options).to_s
          end

          private
          def error_options
            @error_options ||= Attributes[options[:error_options]]
          end

          def wrapper_options
            @wrapper_options ||= Attributes[options[:wrapper_options]]
          end
        end # module InstanceMethods
      end # module WrappedControl
    end # module Modules
  end # class Element
end # module Formular
