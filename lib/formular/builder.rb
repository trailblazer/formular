module Formular
  class Builder
    #this is where we start...
    def initialize(element_set, model)
      @element_set = element_set
      @model = model
    end

    def method_missing(method, *args)
      @element_set[method].new(*args)
    end

    def respond_to?(method, include_private)
      super || @element_set.elements.keys.include?(method)
    end
  end #class Builder
end #module Formular
