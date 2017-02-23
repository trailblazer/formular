module Formular
  module HtmlEscape
    # see activesupport/lib/active_support/core_ext/string/output_safety.rb

    HTML_ESCAPE = { '&' => '&amp;', '>' => '&gt;', '<' => '&lt;', '"' => '&quot;', "'" => '&#39;' }
    HTML_ESCAPE_REGEXP	=	/[&"'><]/
    HTML_ESCAPE_ONCE_REGEXP	=	/["><']|&(?!([a-zA-Z]+|(#\d+)|(#[xX][\dA-Fa-f]+));)/

    # A utility method for escaping HTML tag characters.
    def html_escape(string)
      string.to_s.gsub(HTML_ESCAPE_REGEXP, HTML_ESCAPE)
    end

    # A utility method for escaping HTML without affecting existing escaped entities.
    def html_escape_once(string)
      string.to_s.gsub(HTML_ESCAPE_ONCE_REGEXP, HTML_ESCAPE)
    end
  end
end
