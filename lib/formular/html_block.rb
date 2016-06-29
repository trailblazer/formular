module Formular
  # the Renderer class is responsible for converting an element into an html string using
  # the provided function providing the element as a variable to that function.
  # this class also provides some simple helpers to make it easier to define your html.
  class HtmlBlock
    def initialize(fn)
      @fn = fn
    end

    # this calls our html function passing the element instance as a variable.
    # It returns our html as a string

    # FIXME must be a better way of handling the output buffer
    # but if we don't clear it before a call then we get everything rendered to any instance of
    # this element class
    # FIXME a bit of a fundemental problem here. Because we call instance_exec with renderer as self
    # any local vars or method calls in the block will fail even something as tame as:
    # f.select :select_roles, label: "Roles", collection: roles_array
    # will error because roles_array doesn't exit.
    def call(element)
      @output = ''
      @element = element
      @fn.(element, self).to_s
    end

    # append a string to the output buffer.
    # Useful when your html block is a bit more than one line
    def concat(content)
      @output << content.to_s
    end
  end # class Renderer
end # module Formular
