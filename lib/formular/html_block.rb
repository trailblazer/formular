module Formular
  # the HtmlBlock class is responsible for converting an element into an html string using
  # the provided function providing the element as a variable to that function.
  # this class also provides some simple helpers to make it easier to define your html.
  class HtmlBlock
    def initialize(element, fn)
      @fn = fn
      @element = element
      @context = get_context
    end
    attr_reader :fn, :element

    # this calls our html function passing the element instance as a variable.
    # It returns our html as a string
    def call
      @output = ''
      instance_exec(element, &fn).to_s
    end

    # append a string to the output buffer.
    # Useful when your html block is a bit more than one line
    def concat(content)
      @output << content.to_s
    end

    # return the start/opening tag with the element
    # attributes hash converted into valid html attributes
    def start_tag
      if element.attributes.empty?
        "<#{element.tag}>"
      else
        "<#{element.tag} #{element.attributes.to_html}>"
      end
    end

    # return a closed start tag (e.g. <input name="body"/>)
    def closed_start_tag
      start_tag.gsub(/\>$/, '/>')
    end

    # returns the end/ closing tag for an element
    def end_tag
      "</#{element.tag}>"
    end

    private

    # I will confess that these two come straight from Hanami
    # https://github.com/hanami/helpers/blob/master/lib/hanami/helpers/html_helper/html_builder.rb

    if RUBY_VERSION >= '2.2'# && !Utils.jruby?
      def get_context
        fn.binding.receiver
      end
    else
      def get_context
        eval 'self', fn.binding
      end
    end

    # Forward missing methods to the current context.
    # This allows to access views local variables from nested content blocks.
    #
    # @since 0.1.0
    # @api private
    def method_missing(m, *args, &blk)
      @context.__send__(m, *args, &blk)
    end
  end # class HtmlBlock
end # module Formular
