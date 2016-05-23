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

    def method_missing(method, options={}, &block)
      element = @elements[method]
      if element
        opts = options ? options.merge!({builder: self}) : {builder: self}
        element.(opts, &block)
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
