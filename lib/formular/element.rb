require "formular/attributes"
require "formular/renderer"
require 'uber/inheritable_attr'

module Formular
  class Element
    extend Uber::InheritableAttr
    inheritable_attr :renderer
    inheritable_attr :default_attributes
    inheritable_attr :option_keys

    self.default_attributes = {} #I actually don't want to inherit classes...
                                 #it get's complicated when you want to remove one
    self.option_keys = []

    def self.attribute(key, value)
      self.default_attributes.merge!( {key => value} )
    end

    def self.html(&block)
      self.renderer = Renderer.new(block)
    end

    def self.add_option_keys(keys)
      self.option_keys += keys
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

    def initialize(options={}, &block)
      normalize_attributes(options)
      @block = block
      @tag = self.class.tag_name
      @renderer = self.class.renderer
    end

    attr_reader :tag, :renderer, :builder, :attributes, :options

    def to_html
      renderer.call(self)
    end
    alias_method :to_s, :to_html

    private
    #I'm not convinced by this method but essentially we split the options hash
    #between options and attributes based on the option_keys defined on the class
    #we then get the default attributes from the class & split these in the same way
    #the users options & attributes are then merged with the default options & attributes
    def normalize_attributes(options={})
      @builder = options.delete(:builder)
      @attributes = options
      @options = @attributes.select { |k,v| @attributes.delete(k) if option_key?(k) }

      default_attributes = get_default_attributes
      default_options = default_attributes.select { |k,v| default_attributes.delete(k) if option_key?(k) }

      @options = default_options.merge(@options)
      @attributes = Attributes[default_attributes].merge(@attributes)
    end

    #default attribute values will either be an array of classes, or a string.
    #symbols are treated as method names and we attempt to call them on self.
    #if not then we simply return the symbol
    def get_default_attributes
      attrs = {}
      self.class.default_attributes.each { |k,v| attrs[k] = (v.is_a?(Symbol) && self.respond_to?(v)) ? self.send(v) : v }
      attrs.select{ |k,v| v != nil }
    end

    def option_value(v)
      (v.is_a?(Symbol) && self.respond_to?(v)) ? self.send(v) : v
    end

    def option_key?(k)
      self.class.option_keys.include?(k)
    end
  end #class Element
end #module Formular
