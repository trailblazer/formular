module Formular
  class Renderer
    def initialize(fn)
      @fn = fn
    end

    def call(element)
      @output = "" #I'm sure there are better ways of doing this but if we don't clear it before a
                   # call then we get everything else called to this element class
      @element = element
      instance_exec element, &@fn
    end

    def concat(string)
      @output << string
    end

    def opening_tag(closed=false)
      tag = @element.attributes.empty? ? "<#{@element.tag}>" : "<#{@element.tag} #{@element.attributes.to_html}>"
      tag.gsub!(">", "/>") if closed

      tag
    end

    def closing_tag
      "</#{@element.tag}>"
    end
  end #class Renderer
end #module Formular
