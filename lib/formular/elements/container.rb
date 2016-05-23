require "formular/element"
module Formular
  module Elements
    #this class is used for elements that contain something e.g. <label>Label Words</label>
    #it is designed to accept content as a string, as a block or just provide
    #the open and closing tags

    #unless container should element call return the HTML??
    #does it matter as to_s is there so in a view it would automatically render the html...?
    class Container < Formular::Element
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

      def content
        @block ? Renderer.new(@block).call(self) : options[:content]
      end

      #I don't like this...
      #I'd link be able to define end html in the same way as you
      #can opening (though I can't think of a use case right now...)
      def end
        Renderer.new(Proc.new {closing_tag}).call(self)
      end

      def method_missing(method, *args, &block)
        #if builder&elements are called on me then we attach us at the container(maybe parent)
        if builder
          #attributes, options = args
          #options = options ? options.merge!({container: self}) : {container: self}
          #TODO inject self into options
          builder.send(method, *args, &block)
        else
          super
        end
      end

      def respond_to?(method, include_private = false)
        super || (builder ? builder.respond_to?(method, include_private) : false)
      end
    end #class Container
  end #module Elements
end #module Formular
