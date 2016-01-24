module Formular
  class Attributes < Hash
    def self.[](hash)
      hash ||= {}
      super
    end

    def merge!(hash)
      classes     = self[:class]
      new_classes = hash[:class]
      return super unless classes && new_classes

      hash[:class] += classes
      super
    end
  end
end
