module Formular
  class Renderer
    def initialize(fn)
      @fn = fn
    end

    def call(element)
      @output = ""
      @element = element
      instance_exec @output, element, &@fn
    end

    def opening_tag(closed=false)
      tag = @element.attributes.empty? ? "<#{@element.tag}>" : "<#{@element.tag} #{@element.attributes.to_html}>"
      tag.gsub!(">", "/>") if closed

      tag
    end

    def closing_tag
      "</#{@element.tag}>"
    end
  end
end