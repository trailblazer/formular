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

        add_option_keys [:content]

        html do |element|
          element.content ? element.render(:with_content) : start_tag
        end

        html(:with_content) do |element|
          concat start_tag
          concat element.content
          concat end_tag
        end

        html(:end) do
          end_tag
        end

        module InstanceMethods
          def content
            @block ? Renderer.new(@block).call(self) : options[:content]
          end

          def end
            render(:end)
          end

          # Delegate missing methods to the builder
          def method_missing(method, *args, &block)
            return super unless builder

            builder.send(method, *args, &block)
          end
        end # module InstanceMethods
      end # module Container
    end # module Modules
  end # module Elements
end # module Formular
