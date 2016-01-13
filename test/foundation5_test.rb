require "test_helper"
require "cells-slim"
require "cells-hamlit"

require "formular/frontend/foundation5"

require "reform"
require "reform/form/dry"



module F5
  class Form < Reform::Form
    include Dry::Validations

    property :id
    property :uuid
    property :body

    validation :default do
      key(:uuid) { |uuid| uuid.filled? }
      key(:body) { |body| body.max_size?(10) }
    end

    collection :replies do
      property :email
    end
  end
end



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


class Form < Cell::ViewModel
  include Cell::Slim
  # include Cell::Hamlit
end

class Foundation6Test < Minitest::Spec
  Reply = Struct.new(:email, :errors)

  describe "valid, initial rendering" do
    let (:model) { Comment.new(1, "Nice!", [Reply.new]) }

    it { Comment::NewCell.new(model).().must_equal "<New></New>
<form action=\"/posts\">ID
<input name=\"id\" type=\"text\" value=\"1\" id=\"form_id\" />
<textarea name=\"body\" type=\"text\" id=\"form_body\">Nice!</textarea>
<fieldset><input name=\"replies[email]\" type=\"text\" value=\"\" id=\"form_replies_0_email\" /></fieldset>
<input type=\"button\" value=\"Submit\" /><input name=\"uuid\" type=\"text\" value=\"0x\" id=\"form_uuid\" />
</form>".gsub("\n", "") }
  end


  describe "with errors" do
    let (:model) do
      F5::Form.new(Comment.new(nil, "hang ten in east berlin", []))
    end

    before { model.validate({}) }

    it do
      Comment::NewCell.new(model).().must_equal "<New></New><form action=\"/posts\">ID
<input name=\"id\" type=\"text\" value=\"\" id=\"form_id\" />
<label class=\"error\">
<textarea class=\"error\" name=\"body\" type=\"text\" id=\"form_body\">
hang ten in east berlin
</textarea>
</label>
<small class=\"error\">[\"body size cannot be greater than 10\"]</small>
<input type=\"button\" value=\"Submit\" />
<label class=\"error\">
<input class=\"error\" name=\"uuid\" type=\"text\" value=\"0x\" id=\"form_uuid\" /></label><small class=\"error\">[\"uuid must be filled\"]</small>
</form>".gsub("\n", "")
    end
  end
end
