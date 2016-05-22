require "formular/attributes"
require "formular/renderer"
require 'uber/inheritable_attr'

module Formular
  class Element
    extend Uber::InheritableAttr
    inheritable_attr :renderer
    inheritable_attr :default_attributes
    self.default_attributes = Attributes[{}]

    def self.attribute(key, value)
      self.default_attributes = default_attributes.merge!( Attributes[{key => value}] )
    end

    def self.html(&block)
      self.renderer = Renderer.new(block)
    end

    def self.tag(name)
      @tag_name = name
    end

    def self.tag_name
      @tag_name || name.split("::").last.downcase
    end

    def self.call(*args, &block)
      new(*args, &block)
    end

    def initialize(attributes={}, options={}, &block)
      @attributes = self.class.default_attributes.dup.merge!(Attributes[attributes])
      @options = options
      @builder = options.delete(:builder)
      @block = block
      @tag = self.class.tag_name
      @renderer = self.class.renderer
    end
    attr_reader :attributes, :tag, :renderer, :builder

    # def path(name = nil)
    #   name ? @path << name : @path
    # end

    def to_html
      renderer.call(self)
    end
    alias_method :to_s, :to_html
  end #class Element
end #module Formular
