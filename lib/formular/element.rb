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
    inheritable_attr :processing_hash
    inheritable_attr :option_keys
    inheritable_attr :tag_name

    self.default_hash = {}
    self.processing_hash = {}
    self.html_blocks = {}
    self.html_context = :default
    self.option_keys = []

    # set the default value of an option or attribute
    # you can make this conditional by providing a condition
    # e.g. if: :some_method or unless: :some_method
    # to respect the order defaults are declared, rather than overriting existing defaults
    # we should delete the existing and create a new k/v pair
    def self.set_default(key, value, condition = {})
      self.default_hash.delete(key) # attempt to delete an existing key
      self.default_hash[key] = { value: value, condition: condition }
    end

    # process an option value (i.e. escape html)
    # This occurs after the value has been set (either by default or by user input)
    # you can make this conditional by providing a condition
    # e.g. if: :some_method or unless: :some_method
    def self.process_option(key, processor, condition = {})
      self.processing_hash[key] = { processor: processor, condition: condition }
    end

    # define what your html should look like
    # this block is executed in the context of an HtmlBlock instance
    def self.html(context = :default, &block)
      self.html_blocks[context] = block
    end

    # a convenient way of changing the key for a context
    # useful for inheritance if you want to replace a context
    # but still access the original function
    def self.rename_html_context(old_context, new_context)
      self.html_blocks[new_context] = self.html_blocks.delete(old_context)
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
      @options = options
      normalize_options
      process_options
      @block = block
      @tag = self.class.tag_name
      @html_blocks = define_html_blocks
    end
    attr_reader :tag, :html_blocks, :builder, :options

    def attributes
      attrs = @options.select { |k, v| @options[k] || true unless option_key?(k) }
      Attributes[attrs]
    end

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

    # Options passed into our element instance (@options) take precident over class level defaults
    # Take each default value and merge it with options.
    # This way ordering is important and we can access values as they are evaluated
    def normalize_options
      self.class.default_hash.each do |key, hash|
        should_merge = key.to_s.include?('class') && !options[key].nil?

        # if we've already got a value, and it's not a class then skip
        next unless options[key].nil? || should_merge

        # if our default is conditional and the condition evaluates to false then skip
        next unless evaluate_option_condition?(hash[:condition])

        val = Uber::Options::Value.new(hash[:value]).evaluate(self)

        # if our default value is nil then skip
        next if val.nil?

        # otherwise perform the actual merge, classes get joined, otherwise we overwrite
        should_merge ? @options[key] += val : @options[key] = val
      end
    end

    # Options passed into our element instance (@options) take precident over class level defaults
    # Take each default value and merge it with options.
    # This way ordering is important and we can access values as they are evaluated
    def process_options
      self.class.processing_hash.each do |key, hash|
        # we can't process if our option is nil
        next if options[key].nil?
        # don't process if our condition is false
        next unless evaluate_option_condition?(hash[:condition])

        # get our value
        val = self.send(hash[:processor], options[key]) # TODO enable procs and blocks

        # set our value
        @options[key] = val
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
