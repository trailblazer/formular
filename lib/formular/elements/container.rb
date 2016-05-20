require "formular/element"
module Formular
  module Elements
    #this class is used for elements that contain something e.g. <label>Label Words</label>
    #it is designed to accept content as a string, as a block or just provide
    #the open and closing tags
    class Container < Formular::Element
      html do |output, element|
        if element.content == nil
          opening_tag
        else
          output << opening_tag
          output << element.content
          output << closing_tag
        end
      end

      def content
        @block ? Renderer.new(@block).call(self) : @options[:content]
      end

      #I don't like this...
      #I'd link be able to define end html in the same way as you
      #can opening (though I can't think of a use case right now...)
      def end
        Renderer.new(Proc.new {closing_tag}).call(self)
      end
    end #class Container
  end #module Elements
end #module Formular
