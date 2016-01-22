require "test_helper"
require "cell/slim"

class Comment::NewCell < Cell::ViewModel
  include Cell::Slim
  # include Cell::Hamlit

  self.view_paths = ['test/fixtures']

  def show
    render
  end

  def form(model:nil, **options, &block)
    Formular::Foundation5::Builder.new(model: model).form(options, &block)
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

class SlimTest < Minitest::Spec
  describe "valid, initial rendering" do
    let (:model) { Comment.new(1, "Nice!", [Reply.new]) }

    it { Comment::NewCell.new(model).().must_eq %{<New></New>
<form action="/posts">ID
<input name="id" type="text" id="form_id" value="1" />
<textarea name="body" id="form_body">Nice!</textarea>
<fieldset ><input name="replies[email]" type="text" id="form_replies_0_email" value="" /></fieldset>
<input type="button" value="Submit" /><input name="uuid" type="text" value="0x" id="form_uuid" />
</form>} }
  end


  describe "with errors" do
    let (:model) do
      F5::Form.new(Comment.new(nil, "hang ten in east berlin", []))
    end

    before { model.validate({}) }

    it do
      Comment::NewCell.new(model).().must_eq %{<New></New><form action="/posts">ID
<input name="id" type="text" id="form_id" value="" />
<textarea class="error" name="body" id="form_body">
hang ten in east berlin
</textarea>
<small class="error">["body size cannot be greater than 10"]</small>
<input type="button" value="Submit" />
<input class="error" name="uuid" type="text" value="0x" id="form_uuid" /><small class="error">["uuid must be filled"]</small>
</form>}
    end
  end
end
