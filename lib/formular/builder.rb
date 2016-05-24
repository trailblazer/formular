require "formular/path"
require 'uber/inheritable_attr'
module Formular
  class Builder
    extend Uber::InheritableAttr
    inheritable_attr :elements

    #this is where we start...
    def initialize(model: nil, path: nil, errors: nil, elements: nil)
      @model = model
      @path = path
      @errors = errors || (model? ? model.errors : nil)
      @elements = elements || self.class.elements
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

    attr_reader :model, :errors, :element_set

    def method_missing(method, *args, &block)
      element = @elements[method]
      if element
        if args.size > 1
          name, options = args
        else
          case args.first
          when Symbol then name = args.first
          when Hash then options = args.first
          end
        end

        options ||={}
        options[:builder] = self
        options[:attribute_name] = name if name

        element.(options, &block)
      else
        super
      end
    end

    def respond_to?(method, include_private = false)
      super || @elements.keys.include?(method)
    end

    #these can be called from an element
    def path(appendix = nil)
      appendix ? Path[*@path, appendix] : Path[@path]
    end

    def reader_value(name)
      model? ? model.send(name) || "" : ""
    end
  end #class Builder
end #module Formular
