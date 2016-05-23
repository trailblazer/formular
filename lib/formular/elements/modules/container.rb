require "formular/elements/module"
module Formular
  module Elements
    module Modules
      #this module is used for elements that contain something e.g. <label>Label Words</label>
      #it is designed to accept content as a string, as a block
      #if no content it will just provide the opening tag, you can then add your own content
      #close manually by calling `.end`

      #Should we make this a module too?
      #It would give people alot more flexibility in defining their own elements
      #i.e. inherit of existing and include container
      module Container
        include Formular::Elements::Module

        add_option_keys [:content]

        html do |element|
          if element.content == nil
            opening_tag
          else
            concat opening_tag
            concat element.content
            concat closing_tag
          end
        end

        module InstanceMethods
          def content
            @block ? Renderer.new(@block).call(self) : options[:content]
          end

          #I don't like this...
          #I'd link be able to define end html in the same way as you
          #can opening (though I can't think of a use case right now...)
          def end
            Renderer.new(Proc.new {closing_tag}).call(self)
          end

          #do we inject self into args? would we ever need to know what container
          #an input came from?
          def method_missing(method, *args, &block)
            builder ? builder.send(method, *args, &block) : super
          end

          def respond_to?(method, include_private = false)
            super || (builder ? builder.respond_to?(method, include_private) : false)
          end
        end #module InstanceMethods
      end #module Container
    end #module Modules
  end #module Elements
end #module Formular
