module Formular
  class Attributes < Hash
    def self.[](hash)
      hash ||= {}
      super
    end

    # converts the hash into a string k1=v1 k2=v2
    # replaces underscores with - so we can use regular keys
    # allows one layer of nested hashes so we can define data options as a hash.
    def to_html
      map { |key, value|
        if value.is_a?(Hash)
          value.map { |k,v| %(#{key_to_attr_name(key)}-#{attribute_html(k, v)}) }.join(' ')
        else
          attribute_html(key, value)
        end
      }.join(' ')
    end

    private
    def key_to_attr_name(key)
      key.to_s.gsub('_', '-')
    end

    def val_to_string(value)
      value.is_a?(Array) ? value.join(' ') : value
    end

    def attribute_html(key, value)
      %(#{key_to_attr_name(key)}="#{val_to_string(value)}")
    end
  end # class Attributes
end # module Formular
