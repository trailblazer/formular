require "formular/attributes"
require "formular/html_block"
require 'uber/inheritable_attr'
require 'uber/options'

module Formular
  # The Element class is responsible for defining what the html should look like.
  # This includes default attributes, and the function to use to render the html
  # actual rendering is done via a HtmlBlock class
  class Element
    extend Uber::InheritableAttr

    inheritable_attr :html_context
    inheritable_attr :html_blocks
    inheritable_attr :default_hash
    inheritable_attr :option_keys

    # I actually don't want to merge default classes...
    # it get's complicated with inheritance when you want to remove one
    self.default_hash = {}
    self.html_blocks = {}
    self.html_context = :default
    self.option_keys = []

    # set the default value of an option or attribute
    # you can make this conditional by providing a conditions
    # e.g. if: :some_method or unless: :some_method
    def self.set_default(key, value, conditions = {})
      self.default_hash[key] = { value: value, condition: conditions }
    end

    def self.html(context = :default, &block)
      self.html_blocks[context] = block
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
      @html_blocks = define_html_block_instances
    end
    attr_reader :tag, :html_blocks, :builder, :attributes, :options

    def to_html(context: nil)
      context ||= self.class.html_context
      html_blocks[context].call(self)
    end
    alias_method :to_s, :to_html

    # return the start/opening tag with the elements
    # attributes hash converted into valid html attributes
    def start_tag
      attributes.empty? ? "<#{tag}>" : "<#{tag} #{attributes.to_html}>"
    end

    # return a closed start tag (e.g. <input name="body"/>)
    def closed_start_tag
      start_tag.gsub('>', '/>')
    end

    # returns the end/ closing tag for an element
    def end_tag
      "</#{tag}>"
    end

    private

    def define_html_block_instances
      html_blocks = {}
      self.class.html_blocks.each { |context, block| html_blocks[context] = HtmlBlock.new(block) }
      html_blocks
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
