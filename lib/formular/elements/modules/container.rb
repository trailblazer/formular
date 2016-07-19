require 'formular/elements/module'
module Formular
  module Elements
    module Modules
      # this module is used for elements that contain something
      # e.g. <label>Label Words</label>
      # it is designed to accept content as a string or as a block
      # if no content it will just provide the opening tag,
      # you can then add your own content and close manually by calling `.end`
      module Container
        include Formular::Elements::Module

        add_option_keys :content

        html do |element|
          concat start_tag
          concat element.content
          concat end_tag
        end

        html(:start) { start_tag }

        html(:end) { end_tag }

        module InstanceMethods
          def content
            @block ? HtmlBlock.new(self, @block).call : options[:content].to_s
          end

          def has_content?
            @block || options[:content]
          end

          def end
            to_html(context: :end)
          end

          def start
            to_html(context: :start)
          end

          # Delegate missing methods to the builder
          # TODO:: @apotonick is going to do something fancy here to delegate
          # the builder methods rather then using this method missing.
          def method_missing(method, *args, &block)
            return super unless builder

            builder.send(method, *args, &block)
          end
        end # module InstanceMethods
      end # module Container
    end # module Modules
  end # module Elements
end # module Formular
