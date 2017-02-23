require 'formular/element/module'
require 'formular/html_escape'
module Formular
  class Element
    module Modules
      # this module provides label options and methods to a control when included.
      module Label
        include Formular::Element::Module
        include HtmlEscape
        add_option_keys :label, :label_options

        # options functionality:
        # options[:label] == String return the string
        # currently we don't infer label text so if you don't include
        # label as an option, you wont get one rendered
        module InstanceMethods
          def label_text
            return if options[:label].nil? || options[:label] == false
            html_escape(options[:label])
          end

          def has_label?
            !label_text.nil? && label_text != false
          end

          def label_options
            @label_options ||= options[:label_options] || {}
          end
        end # module InstanceMethods
      end # module Label
    end # module Modules
  end # class Element
end # module Formular
