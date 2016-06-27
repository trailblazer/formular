require 'formular/path'
require 'uber/inheritable_attr'
module Formular
  class Builder
    extend Uber::InheritableAttr
    inheritable_attr :elements

    def self.element_set(elements)
      @elements = elements
      define_element_methods(elements)
    end

    # this defines a method for each element in the set.
    # This might be a little magical, but I did it in the interests of dryness as I had many
    # methods with exactly the same code... Happy to revert if this is code smell!
    def self.define_element_methods(elements)
      elements.each do |element_name, element_class|
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
    end

    # this is where we start...
    def initialize(model: nil, path: nil, errors: nil, elements: nil)
      @model = model
      @path = path
      @errors = errors || (model? ? model.errors : nil)
      @elements = elements || self.class.elements
      self.class.define_element_methods(elements) if elements
    end

    def model?
      @model != nil
    end

    def capture(*args)
      yield(*args)
    end

    def call(&block)
      capture(self, &block)
    end

    attr_reader :model, :errors, :elements

    # these can be called from an element
    def path(appendix = nil)
      appendix ? Path[*@path, appendix] : Path[@path]
    end

    def reader_value(name)
      model? ? model.send(name) : nil
    end
  end # class Builder
end # module Formular
