module Formular
  class Attributes < Hash
    def self.[](hash)
      hash ||= {}
      super
    end

    def merge(hash)
      dup.merge!(hash)
    end

    def merge!(hash)
      classes     = self[:class]
      new_classes = hash[:class]
      return super unless classes && new_classes

      hash[:class] += classes
      super
    end

    # converts the hash into a string k1=v1 k2=v2
    # replaces underscores with - so we can use regular keys
    # allows one layer of nestedhashes so we can define data options as a hash.
    def to_html
      map do |key,val|
        if val.is_a?(Hash)
          val.map do |k,v|
            %(#{key_to_attr_name(key)}-#{key_to_attr_name(k)}="#{val_to_string(v)}")
          end.join(" ")
        else
           %(#{key_to_attr_name(key)}="#{val_to_string(val)}")
        end
      end.join(" ")
    end

    private
    def key_to_attr_name(key)
      key.to_s.gsub('_', '-')
    end

    def val_to_string(value)
      value.is_a?(Array) ? value.join(' ') : value
    end
  end # class Attributes
end # module Formular
