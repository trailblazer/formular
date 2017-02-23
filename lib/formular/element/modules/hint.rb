require 'formular/element/module'
require 'formular/html_escape'
module Formular
  class Element
    module Modules
      # this module provides hints to a control when included.
      module Hint
        include Formular::Element::Module
        include HtmlEscape
        add_option_keys :hint, :hint_options

        # options functionality (same as SimpleForm):
        # options[:hint] == String return the string
        module InstanceMethods
          def hint_text
            html_escape(options[:hint]) if has_hint?
          end

          def has_hint?
            options[:hint].is_a?(String)
          end

          private
          def hint_id
            return hint_options[:id] if hint_options[:id]

            id = options[:id] || form_encoded_id
            "#{id}_hint" if id
          end

          def hint_options
            @hint_options ||= options[:hint_options] || {}
          end
        end # module InstanceMethods
      end # module Hint
    end # module Modules
  end # class Element
end # module Formular
