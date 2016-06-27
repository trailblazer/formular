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
          if element.content
            concat start_tag
            concat element.content
            concat end_tag
          else
            start_tag
          end
        end

        module InstanceMethods
          def content
            @block ? Renderer.new(@block).call(self) : options[:content]
          end

          # I don't like this...
          # I'd link be able to define end html in the same way as you
          # can opening (though I can't think of a use case right now...)
          def end
            Renderer.new(Proc.new { end_tag }).call(self)
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
