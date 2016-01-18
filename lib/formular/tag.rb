module Formular
  # Generic renderer functions without any state.
  class Tag
    def call(name, attributes:{}, content:nil, **)
      return %{<#{name} #{html_attrs(attributes)} />} unless content
      %{<#{name} #{html_attrs(attributes)}>#{content}</#{name}>}
    end

    def html_attrs(attributes)
      if class_attr = attributes[:class]
        attributes = attributes.merge(class: class_attr.join(" "))
      end

      attributes.collect { |k,v| %{#{k}="#{v}"} }.join(" ")
    end
  end
end
