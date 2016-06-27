require "formular/attributes"
require "formular/renderer"
require 'uber/inheritable_attr'

module Formular
  # The Element class is responsible for defining what the html should look like.
  # This includes default attributes, and the function to use to render the html
  # actual rendering is done via a Renderer class
  class Element
    extend Uber::InheritableAttr
    inheritable_attr :renderer
    inheritable_attr :default_hash
    inheritable_attr :option_keys

    # I actually don't want to merge default classes...
    # it get's complicated with inheritance when you want to remove one
    self.default_hash = {}

    self.option_keys = []

    # set the default value of an option or attribute
    def self.set_default(key, value)
      self.default_hash.merge!( {key => value} )
    end

    def self.html(&block)
      self.renderer = Renderer.new(block)
    end

    # whitelist the keys that should end up as html attributes
    def self.add_option_keys(keys)
      self.option_keys += keys
    end

    def self.tag(name)
      @tag_name = name
    end

    # @apotonick if you don't like the magic here we could make you specify a tag in
    # every element class. You could then inherit the attribute.
    def self.tag_name
      @tag_name || name.split("::").last.downcase
    end

    def self.call(options={}, &block)
      new(options, &block)
    end

    def initialize(options={}, &block)
      @builder = options.delete(:builder)
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

    # I'm not convinced by this method but essentially we split the options hash
    # between options and attributes based on the option_keys defined on the class
    # we then get the default attributes from the class & split these in the same way
    # the users options & attributes are then merged with the default options & attributes
    def normalize_attributes(options={})
      @attributes = options
      @options = @attributes.select { |k,v| @attributes.delete(k) || true if option_key?(k) }

      default_attributes = get_defaults
      default_options = default_attributes.select do |k,v|
        default_attributes.delete(k) || true  if option_key?(k)
      end

      @options = default_options.merge(@options)
      @attributes = Attributes[default_attributes].merge(@attributes)
    end

    # default values will either be an array of classes, a string, or symbol.
    # symbols are treated as method names and we attempt to call them on self.
    # if not then we simply return the symbol
    def get_defaults
      attrs = {}
      self.class.default_hash.each do |k,v|
        attrs[k] = (v.is_a?(Symbol) && self.respond_to?(v)) ? self.send(v) : v
      end
      attrs.select{ |k,v| v != nil }
    end

    def option_value(v)
      (v.is_a?(Symbol) && self.respond_to?(v)) ? self.send(v) : v
    end

    def option_key?(k)
      self.class.option_keys.include?(k)
    end
  end # class Element
end # module Formular
