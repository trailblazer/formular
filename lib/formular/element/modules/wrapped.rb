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
      module Wrapped
        include Formular::Element::Module
#        include Control
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
            builder.send(wrapper_element, wrapper_options, &block)
          end

          def label
            return '' unless has_label?

            label_opts = label_options.dup
            label_opts[:content] = label_text
            label_opts[:labeled_control] = self
            builder.label(label_opts).to_s
          end

          def error
            return '' unless has_errors?

            error_options[:content] = error_text
            builder.error(error_options).to_s
          end

          def hint
            return '' unless has_hint?
            hint_opts = hint_options.dup
            hint_opts[:content] = hint_text
            hint_opts[:id] = hint_id # FIXME: this should work like a standard set_default
            builder.hint(hint_opts).to_s
          end

          private
          def error_options
            @error_options ||= options[:error_options] || {}
          end

          def wrapper_options
            @wrapper_options ||= options[:wrapper_options] || {}
          end
        end # module InstanceMethods
      end # module Wrapped
    end # module Modules
  end # class Element
end # module Formular
