require 'formular/path'
require 'uber/inheritable_attr'
module Formular
  class Builder
    extend Uber::InheritableAttr
    inheritable_attr :elements
    self.elements = {}


    def self.element_set(**elements)
      self.elements.merge!(elements)
      define_element_methods(self.elements)
    end

    def self.define_element_methods(**elements)
      elements.each { |k, v| define_element_method(k, v) }
    end

    def self.define_element_method(element_name, element_class)
      define_method(element_name) do |*args, &block|
        if args.size > 1
          name, options = args
        else
          case args.first
          when Symbol then name = args.first
          when Hash then options = args.first
          end
        end

        options ||= {}
        options[:builder] = self
        options[:attribute_name] = name if name

        element_class.(options, &block)
      end
    end

    def initialize(**elements)
      @elements = self.class.elements.merge(elements)
      self.class.define_element_methods(elements) if elements
    end
    attr_reader :elements

    def capture(*args)
      yield(*args)
    end

    def call(&block)
      capture(self, &block)
    end
  end # class Builder
end # module Formular
