module Formular
  # the Renderer class is responsible for converting an element into an html string using
  # the provided function providing the element as a variable to that function.
  # this class also provides some simple helpers to make it easier to define your html.
  class Renderer
    def initialize(fn)
      @fn = fn
    end

    # this calls our html function passing the element instance as a variable.
    # It returns our html as a string

    # FIXME must be a better way of handling the output buffer
    # but if we don't clear it before a call then we get everything rendered to any instance of
    # this element class
    def call(element)
      @output = ''
      @element = element
      instance_exec(element, &@fn).to_s
    end

    # append a string to the output buffer.
    # Useful when your html block is a bit more than one line
    def concat(content)
      @output << content.to_s
    end

    # return the start/opening tag with the elements
    # attributes hash converted into valid html attributes
    def start_tag
      @element.attributes.empty? ? "<#{@element.tag}>" : "<#{@element.tag} #{@element.attributes.to_html}>"
    end

    # return a closed start tag (e.g. <input name="body"/>)
    def closed_start_tag
      start_tag.gsub('>', '/>')
    end

    # returns the end/ closing tag for an element
    def end_tag
      "</#{@element.tag}>"
    end
  end # class Renderer
end # module Formular
