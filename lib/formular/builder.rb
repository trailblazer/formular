require "formular/path"
require 'uber/inheritable_attr'
module Formular
  class Builder
    extend Uber::InheritableAttr
    inheritable_attr :elements

    #this is where we start...
    def initialize(model: nil, path: nil, errors: nil, elements: nil)
      @model = model
      @path = path || @model.class
      @errors = errors || model != nil ? model.errors : {}
      @elements = elements || self.class.elements
    end

    def model?
      @model != nil
    end

    attr_reader :model, :errors, :element_set

    #TODO:: support more flexible options...
    def method_missing(method, *args, &block)
      element = @elements[method]
      if element
        attributes, options = args
        options = options ? options.merge!({builder: self}) : {builder: self}
        element.(attributes, options, &block)
      else
        super
      end
    end

    def respond_to?(method, include_private = false)
      super || @elements.keys.include?(method)
    end

    private
    def path(appendix = nil)
      appendix ? Path[*@path, appendix] : Path[@path]
    end

    def reader_value(name)
      model? ? model.send(name) || "" : ""
    end
  end #class Builder
end #module Formular
