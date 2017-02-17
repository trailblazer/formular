require 'test_helper'
require 'formular/helper'
require 'trailblazer/cell'
require 'cell/slim'

class Comment::Slim
  class Show < Trailblazer::Cell
    include Cell::Slim
    include Formular::Helper

    self.view_paths = ['test/fixtures']

    def show
      render view: :show
    end

    # def form(model: nil, **options, &block)
    #   Formular::Builders::Basic.new(model: model, path_prefix: :comment).form(options, &block)
    # end
  end
end

class SlimTest < Minitest::Spec
  describe 'valid, initial rendering' do
    let(:model) { Comment.new(1, 'Nice!', [Reply.new(1, 'some exciting words'), Reply.new], Owner.new(1, 'Joe Blog', 'joe@somewhere.com'), '0x', true) }

    it do
      Comment::Slim::Show.new(model).().must_equal %(<div>New</div><form action="/posts" method="post" accept-charset="utf-8"><input name="utf8" type="hidden" value="✓"/><input name="comment[id]" id="comment_id" value="1" type="text"/><input value="given value" name="comment[no_model_method]" id="comment_no_model_method" type="text"/><textarea name="comment[body]" id="comment_body">Nice!</textarea><input value="0" name="comment[public]" type="hidden"/><input value="true" name="comment[public]" id="comment_public" type="checkbox" checked="checked"/><input name="comment[replies][][content]" id="comment_replies_0_content" value="some exciting words" type="text"/><input name="comment[replies][][content]" id="comment_replies_1_content" type="text"/><input name="comment[owner][name]" id="comment_owner_name" value="Joe Blog" type="text"/><input name="comment[owner][email]" id="comment_owner_email" value="joe@somewhere.com" type="text"/><input name="comment[uuid]" id="comment_uuid" value="0x" type="text"/><input value="Submit" type="submit"/></form>)
    end
  end
end

#   describe "with errors" do
#     let (:model) do
#       F5::Form.new(Comment.new(nil, "hang ten in east berlin", []))
#     end
#
#     before { model.validate({}) }
#
#     it do
#       Comment::SlimCell.new(model).().must_eq %{<New></New><form action="/posts">ID
# <input type="text" name="id" id="form_id" value="" />
# <textarea class="error" name="body" id="form_body">
# hang ten in east berlin
# </textarea>
# <small class="error">["body size cannot be greater than 10"]</small>
# <input type="button" value="Submit" />
# <input class="error" type="text" value="0x" name="uuid" id="form_uuid" /><small class="error">["uuid must be filled"]</small>
# </form>}
#     end
#   end
# end
