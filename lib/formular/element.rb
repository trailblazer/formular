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
    inheritable_attr :tag_name

    self.default_hash = {}
    self.html_blocks = {}
    self.html_context = :default
    self.option_keys = []

    # set the default value of an option or attribute
    # you can make this conditional by providing a condition
    # e.g. if: :some_method or unless: :some_method
    # if you provide a :method option, you can mutate an existing
    # default rather than overriding it
    def self.set_default(key, value, **options)
      method = options.delete(:method)
      condition = options

      val = if method.nil?
              value
            else
              default_hash[key][:value].dup.send(method, value)
            end

      self.default_hash[key] = { value: val, condition: condition }
    end

    # define what your html should look like
    # this block is executed in the context of an HtmlBlock instance
    def self.html(context = :default, &block)
      self.html_blocks[context] = block
    end

    # blacklist the keys that should NOT end up as html attributes
    def self.add_option_keys(*keys)
      self.option_keys += keys
    end

    # define the name of the html tag for the element
    # e.g.
    # tag :span
    # tag 'input'
    # Note that if you leave this out, the tag will be inferred
    # based on the name of your class
    # Also, this is not inherited
    def self.tag(name)
      self.tag_name = name
    end

    def self.call(**options, &block)
      new(**options, &block)
    end

    def initialize(**options, &block)
      @builder = options.delete(:builder)
      normalize_attributes(options)
      @block = block
      @tag = self.class.tag_name
      @html_blocks = define_html_blocks
    end
    attr_reader :tag, :html_blocks, :builder, :attributes, :options

    def to_html(context: nil)
      context ||= self.class.html_context
      html_blocks[context].call
    end
    alias_method :to_s, :to_html

    private

    def define_html_blocks
      self.class.html_blocks.each_with_object({}) do |(context, block), hash|
        hash[context] = HtmlBlock.new(self, block)
      end
    end

    # we split the options hash between options and attributes
    # based on the option_keys defined on the class
    # we then get the default_hash from the class
    # and merge with the user options and attributes
    def normalize_attributes(**options)
      @attributes = Attributes[options]
      @options = @attributes.select { |k, v| @attributes.delete(k) || true if option_key?(k) }
      merge_default_hash
    end

    # Take each default value and merge it with attributes && options.
    # This way ordering is important and we can access values as they are evaluated
    def merge_default_hash
      self.class.default_hash.each do |k, v|
        next unless evaluate_option_condition?(v[:condition])

        val = Uber::Options::Value.new(v[:value]).evaluate(self)

        next if val.nil?

        if option_key?(k)
          @options[k] = val if @options[k].nil?
        else
          # make sure that we merge classes, not override them
          k == :class && !@attributes[k].nil? ? @attributes[k] += val : @attributes[k] ||= val
        end
      end
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
      when :if     then condition_result
      when :unless then !condition_result
      end
    end
  end # class Element
end # module Formular
