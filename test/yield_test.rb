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

    def form(model:nil, **options, &block)
      Builder.new(model: model).form(options, &block)
    end

    # <label class="error">Error
    #   <input type="text" class="error" />
    # </label>
    # <small class="error">Invalid entry</small>
    class Builder < Formular::Builder
      def input(options)
        shared = { class: [:error] }

        input = @element.tag(:input, attributes: shared.merge(options))

        @element.tag(:label, attributes: shared, content: input) +
        @element.tag(:small, attributes: shared, content: "Error here!")
      end
    end
    # TODO: TEST that attributes hash is immutuable.

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
end

class YieldTest < Minitest::Spec
  Reply = Struct.new(:email)

  it { Comment::NewCell.new(nil).().must_equal "<New></New><form action=\"/posts\">ID<input name=\"id\" /><fieldset><input name=\"replies.email\" /></fieldset><input type=\"button\" value=\"Submit\" name=\"\" /></form>" }
end
