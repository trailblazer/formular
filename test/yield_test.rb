require "test_helper"
require "cells-slim"
require "cells-hamlit"

module Comment
  class NewCell < Cell::ViewModel
    include Cell::Slim
    # include Cell::Hamlit

    self.view_paths = ['test/fixtures']

    def show
      render
    end

    def form(options, &block)
      Form.new(nil, options.merge(block: block)).(:form)
    end
  end
end

#@template=#<Erbse::Template:0x9aa53f8 @src="
# @output_buffer = output_buffer;
# @output_buffer.safe_append='New\n\n'.freeze;
# @output_buffer.append=  form model do |f|
# @output_buffer.safe_append='\n  ID for '.freeze;@output_buffer.append=( model.class );@output_buffer.safe_append=': '.freeze;@output_buffer.append=( f.input :id );@output_buffer.safe_append='\n'.freeze;   #raise \n end \n@output_buffer.safe_append='\n'.freeze; inner = capture do \n@output_buffer.safe_append='\n  '.freeze;@output_buffer.append=( self.class );@output_buffer.safe_append='\n'.freeze; end \n@output_buffer.to_s

class Cell::ViewModel
  module Capture
    # Only works with Slim, so far.
    def capture(*args)
      yield(*args)
    end
  end
end


class Form < Cell::ViewModel
  include Cell::Slim
  # include Cell::Hamlit

include Capture

  def form
    content = capture(self, &options[:block])
# TODO: make that form(options) and not show.

    %{<form #{html_attrs(options)}>
#{content}
</form>}
  end

  def nested(name, &block)
    nested = options[:model].send(name)
    # TODO: implement for collection, too. (magic or explicit collection: true?)
    # TODO: handle nil/[]
    # TODO: n-level nesting: path with local_path+
    self.class.new(nil, model: nested, block: block, path: [name]).(:fieldset)
  end

  def input(options={})
    options[:name] = ((@options[:path] || []) + [options[:name]]).join(".")

    Element.new.input(options)
  end

  # Generic renderer functions without any state.
  class Element
    def input(options)
      %{<input #{html_attrs(options)} />}
    end

    def html_attrs(options)
      options.collect { |k,v| %{#{k}="#{v}"} }.join(" ")
    end
  end

  def button(options={})
    input({ type: :button }.merge(options))
  end

  def fieldset
    content = options[:model].collect do |model|
      options[:block].call(self) # FIXME: this should be a separate instance for every call? so we can use it for dynamic forms?
    end.join("")

    %{<fieldset>#{content}</fieldset>}
  end

private
  def html_attrs(options)
    options.collect { |k,v| %{#{k}="#{v}"} }.join(" ")
  end
end

class YieldTest < Minitest::Spec
  Reply = Struct.new(:email)

  it { Comment::NewCell.new(nil).().must_equal "<New></New><form>
ID<input id><form>
Title<input title>
</form>
</form>" }
end
