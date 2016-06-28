require "test_helper"
require "formular/builders/basic"
require 'tilt'
require "trailblazer/cell"
require "cells-erb"
class Comment::Erb
  class Show < Trailblazer::Cell
    include Cell::Erb

    self.view_paths = ['test/fixtures']

    def show
      render
    end

    def form(model:nil, **options, &block)
      Formular::Builders::Basic.new(model: model, path: :comment).form(options, &block)
    end
  end
end

class Erb < Minitest::Spec
  #FIXME don't ask me why erb makes so much white space...
  describe "valid, initial rendering" do
    let (:model) { Comment.new(1, "Nice!", [Reply.new(1, "some exciting words"), Reply.new], Owner.new(1, "Joe Blog", "joe@somewhere.com"), "0x", true) }

    it do
      Comment::Erb::Show.new(model).().must_equal %{<div>New</div>
<form method="post" action="/posts">
<input name="comment[id]" id="comment_id" value="1" type="text"/>
<textarea name="comment[body]" id="comment_body">Nice!</textarea>
<input name="comment[public][]" id="comment_public" checked="checked" type="checkbox" value="true"/>

<input name="comment[replies][][content]" id="comment_replies_0_content" value="some exciting words" type="text"/>

<input name="comment[replies][][content]" id="comment_replies_1_content" type="text"/>



<input name="comment[owner][name]" id="comment_owner_name" value="Joe Blog" type="text"/>
<input name="comment[owner][email]" id="comment_owner_email" value="joe@somewhere.com" type="text"/>

<input name="comment[uuid]" id="comment_uuid" value="0x" type="text"/>
<input type="submit" value="Submit"/>
</form>}
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
#end