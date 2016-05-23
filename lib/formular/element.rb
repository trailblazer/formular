require "formular/attributes"
require "formular/renderer"
require 'uber/inheritable_attr'

module Formular
  class Element
    extend Uber::InheritableAttr
    inheritable_attr :renderer
    inheritable_attr :default_attributes
    inheritable_attr :option_keys

    self.default_attributes = Attributes[{}]
    self.option_keys = []

    def self.attribute(key, value)
      self.default_attributes = default_attributes.merge!( {key => value} )
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
    def normalize_attributes(options={})
      @builder = options.delete(:builder)
      opts = {}
      attrs = {}
      options.each { |k,v| option_key?(k) ? opts[k] = v : attrs[k] = v }
      @attributes = self.class.default_attributes.dup.merge!(Attributes[attrs])
      @options = opts
    end

    def option_key?(k)
      self.class.option_keys.include?(k)
    end
  end #class Element
end #module Formular
