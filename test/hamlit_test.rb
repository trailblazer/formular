require "test_helper"
require "cell/hamlit"

class Comment::EditCell < Cell::ViewModel
  include Cell::Hamlit

  self.view_paths = ['test/fixtures']

  def show
    render
  end

  def form(model:nil, **options, &block)
    Formular::Foundation5::Builder.new(model: model).form(options, &block)
  end
end

class HamlitTest < Minitest::Spec
  describe "valid, initial rendering" do
    let (:model) { Comment.new(1, "Nice!", [Reply.new]) }

    it { Comment::EditCell.new(model).().must_eq %{Edit
<form action="/posts">ID
<input name="id" type="text" id="form_id" value="1" />
<textarea name="body" id="form_body">Nice!</textarea>
<fieldset ><input name="replies[email]" type="text" id="form_replies_0_email" value="" /></fieldset>
<input type="button" value="Submit" /><input name="uuid" type="text" value="0x" id="form_uuid" />
</form>} }
  end
end
