require "formular/attributes"
require "formular/renderer"
require 'uber/inheritable_attr'
require 'uber/options'

module Formular
  # The Element class is responsible for defining what the html should look like.
  # This includes default attributes, and the function to use to render the html
  # actual rendering is done via a Renderer class
  class Element
    extend Uber::InheritableAttr

    inheritable_attr :render_context
    inheritable_attr :renderers
    inheritable_attr :default_hash
    inheritable_attr :option_keys

    # I actually don't want to merge default classes...
    # it get's complicated with inheritance when you want to remove one
    self.default_hash = {}
    self.renderers = {}
    self.option_keys = []
    self.render_context = :default

    # set the default value of an option or attribute
    # you can make this conditional by providing a conditions
    # e.g. if: :some_method or unless: :some_method
    def self.set_default(key, value, conditions = {})
      self.default_hash[key] = { value: value, condition: conditions }
    end

    def self.html(context = :default, &block)
      self.renderers[context] = Renderer.new(block)
    end

    # whitelist the keys that should NOT end up as html attributes
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
      @renderers = dup_class_renderers
    end

    attr_reader :tag, :renderers, :builder, :attributes, :options

    def render(context = nil)
      context ||= self.class.render_context
      renderers[context].call(self)
    end

    def to_html
      render
    end
    alias_method :to_s, :to_html

    private

    # until we can isolate the output buffer in the renderer sufficiently,
    # we need a fresh instance of each renderer for every element instance
    def dup_class_renderers
      renderers = {}
      self.class.renderers.each { |k, v| renderers[k] = v.dup }
      renderers
    end

    # I'm not convinced by this method but essentially we split the options hash
    # between options and attributes based on the option_keys defined on the class
    # we then get the default attributes from the class & split these in the same way
    # the users options & attributes are then merged with the default options & attributes
    def normalize_attributes(options={})
      @attributes = options
      @options = @attributes.select { |k, v| @attributes.delete(k) || true if option_key?(k) }

      default_attributes = default_hash
      default_options = default_attributes.select do |k, v|
        default_attributes.delete(k) || true if option_key?(k)
      end

      @options = default_options.merge(@options)
      @attributes = Attributes[default_attributes].merge(@attributes)
    end

    # default values will either be an array of classes, a string, or symbol.
    # symbols are treated as method names and we attempt to call them on self.
    # if not then we simply return the symbol
    def default_hash
      attrs = {}
      self.class.default_hash.each do |k, v|
        next unless evaluate_option_condition?(v[:condition])

        attrs[k] = v[:value]
      end

      Uber::Options.new(attrs).evaluate(self).select{ |k, v| !v.nil? }
    end

    def option_key?(k)
      self.class.option_keys.include?(k)
    end

    # this evaluates any conditons placed on our defaults returning true or false
    # e.g.
    # set_default :checked, "checked", if: :is_checked?
    # set_default :class, ["form-control"], unless: :file_input?
    def evaluate_option_condition?(condition = {})
      return true if condition.empty?
      operator = condition.keys[0]
      condition_result = Uber::Options::Value.new(condition.values[0]).evaluate(self)

      case operator.to_sym
      when :if
        condition_result
      when :unless
        !condition_result
      end
    end
  end # class Element
end # module Formular
