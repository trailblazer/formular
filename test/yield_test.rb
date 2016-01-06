require "test_helper"
require "cells-slim"

module Comment
  class NewCell < Cell::ViewModel
    include Cell::Slim
    self.view_paths = ['test/fixtures']

    def show
      render
    end

    def form(model, &block)
      Form.new(model, block: block).to_s
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
    # this is capture copied from AV:::CaptureHelper without doing escaping.
    def capture(*args)
      value = nil
      buffer = with_output_buffer { value = yield(*args) }

      return buffer.to_s if buffer.size > 0
      value # this applies for "Beachparty" string-only statements.
    end

    def with_output_buffer(block_buffer=OutputBuffer.new)
      @output_buffer, old_buffer = block_buffer, @output_buffer
      yield
      @output_buffer = old_buffer

      block_buffer
    end
  end
end


class Form < Cell::ViewModel
  include Cell::Slim

include Capture

  def show
    puts "@@@@@ Form:: #{output_buffer.object_id}"
     content = capture(self, &options[:block])

    "<form>
#{content}
</form>"
  end

  def input(name)
    "<input #{name}>"
  end
end

class YieldTest < Minitest::Spec
  it { Comment::NewCell.new(nil).().must_equal "<New></New><form>
ID<input id><form>
Title<input title>
</form>
</form>" }
end
