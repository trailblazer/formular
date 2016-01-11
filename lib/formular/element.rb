module Formular
  # Generic renderer functions without any state.
  class Element
    def input(options)
      %{<input #{html_attrs(options)} />}
    end

    def html_attrs(options)
      options.collect { |k,v| %{#{k}="#{v}"} }.join(" ")
    end

    def form(options)
      %{<form #{html_attrs(options[:attributes])}>#{options[:content]}</form>}
    end

    def fieldset(attributes:{}, content:)
      %{<fieldset>#{content}</fieldset>}
    end
  end
end
