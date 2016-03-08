require "test_helper"
require "cell/hamlit"

class Comment::HamlitCell < Cell::ViewModel
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

    it { Comment::HamlitCell.new(model).().must_eq %{Edit
<form action="/posts">ID
<input type="text" name="id" id="form_id" value="1" />
<textarea name="body" id="form_body">Nice!</textarea>
<fieldset ><input type="text" name="replies[][email]" id="form_replies_0_email" value="" /></fieldset>
<input type="button" value="Submit" /><input type="text" value="0x" name="uuid" id="form_uuid" />
</form>} }
  end
end
