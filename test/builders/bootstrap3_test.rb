require 'test_helper'
require "formular/builders/bootstrap3"

describe Formular::Builders::Bootstrap3 do
  let(:model) { Comment.new(nil, "Something exciting", [Reply.new], Owner.new, nil, 1) }
  let(:builder) { Formular::Builders::Bootstrap3.new(model: model, path: :comment) }

  describe "returns html correctly" do
    it "#outputs with block" do
      form = builder.form(action: "/questions/13") { |f| f.input(:body, label: "Body").to_s }
      form.to_s.must_equal %(<form method="post" action="/questions/13"><div class="form-group"><label for="comment_body" class="control-label">Body</label><input name="comment[body]" id="comment_body" value="Something exciting" type="text" class="form-control"/></div></form>)
    end

    it "#outputs without block (use end)" do
      form = builder.form(action: "/questions/13", method: "put")
      html = form.to_s
      html << form.textarea(:body, label: "Body").to_s
      html << form.select(:public, collection: [[1,"Yes"], [0, "No"]], label: "Public").to_s
      html << form.input(:body, label: "Body").to_s
      html << form.end

      html.must_equal %(<form method="put" action="/questions/13"><div class="form-group"><label for="comment_body" class="control-label">Body</label><textarea name="comment[body]" id="comment_body" class="form-control">Something exciting</textarea></div><div class="form-group"><label for=\"comment_public\" class="control-label">Public</label><select name="comment[public]" id="comment_public" class="form-control"><option value="1" selected="selected">Yes</option><option value="0">No</option></select></div><div class="form-group"><label for="comment_body" class="control-label">Body</label><input name="comment[body]" id="comment_body" value="Something exciting" type="text" class="form-control"/></div></form>)
    end

    it "please ignore my labels" do
      form = builder.form(action: "/questions/13", method: "put")
      html = form.to_s
      html << form.textarea(:body).to_s
      html << form.select(:public, collection: [[1,"Yes"], [0, "No"]]).to_s
      html << form.input(:body).to_s
      html << form.end

      html.must_equal %(<form method="put" action="/questions/13"><div class="form-group"><textarea name="comment[body]" id="comment_body" class="form-control">Something exciting</textarea></div><div class="form-group"><select name="comment[public]" id="comment_public" class="form-control"><option value="1" selected="selected">Yes</option><option value="0">No</option></select></div><div class="form-group"><input name="comment[body]" id="comment_body" value="Something exciting" type="text" class="form-control"/></div></form>)
    end

    it "please use custom labels" do
      form = builder.form(action: "/questions/13", method: "put")
      html = form.to_s
      html << form.textarea(:body, label: "Some fancy label").to_s
      html << form.select(:public, collection: [[1,"Yes"], [0, "No"]], label: "Another fancy label").to_s
      html << form.input(:body, label: "Oh look, here's another fancy label").to_s
      html << form.end

      html.must_equal %(<form method="put" action="/questions/13"><div class="form-group"><label for="comment_body" class="control-label">Some fancy label</label><textarea name="comment[body]" id="comment_body" class="form-control">Something exciting</textarea></div><div class="form-group"><label for=\"comment_public\" class="control-label">Another fancy label</label><select name="comment[public]" id="comment_public" class="form-control"><option value="1" selected="selected">Yes</option><option value="0">No</option></select></div><div class="form-group"><label for="comment_body" class="control-label">Oh look, here's another fancy label</label><input name="comment[body]" id="comment_body" value="Something exciting" type="text" class="form-control"/></div></form>)
    end
  end

  it "calls correct elements" do
    form = builder.form(action: "/questions/13", method: "put")
    form.input(:body, label: "Body").class.must_equal Formular::Elements::Bootstrap3::Input
    form.select(:public, collection: [[1,"Yes"], [0, "No"]], label: "Public").class.must_equal Formular::Elements::Bootstrap3::Select
  end
end

describe Formular::Builders::Bootstrap3Horizontal do
  let(:model) { Comment.new(nil, "Something exciting", [Reply.new], Owner.new) }
  let(:builder) { Formular::Builders::Bootstrap3Horizontal.new(model: model, path: :comment) }

  describe "returns html correctly" do
    it "#outputs with block" do
      form = builder.form(action: "/questions/13") { |f| f.input(:body, label: "Body").to_s }
      form.to_s.must_equal %(<form method="post" class="form-horizontal" action="/questions/13"><div class="form-group"><label for="comment_body" class="col-sm-2 control-label">Body</label><div class="col-sm-10"><input name="comment[body]" id="comment_body" value="Something exciting" type="text" class="form-control"/></div></div></form>)
    end

    it "#outputs without block (use end)" do
      form = builder.form(action: "/questions/13", method: "put")
      html = form.to_s
      html << form.input(:body, label: "Body").to_s
      html << form.end

      html.must_equal %(<form method="put" class="form-horizontal" action="/questions/13"><div class="form-group"><label for="comment_body" class="col-sm-2 control-label">Body</label><div class="col-sm-10"><input name="comment[body]" id="comment_body" value="Something exciting" type="text" class="form-control"/></div></div></form>)
    end
  end
end

describe Formular::Builders::Bootstrap3Inline do
  let(:model) { Comment.new(nil, "Something exciting", [Reply.new], Owner.new) }
  let(:builder) { Formular::Builders::Bootstrap3Inline.new(model: model, path: :comment) }

  describe "returns html correctly" do
    it "#outputs with block" do
      form = builder.form(action: "/questions/13") { |f| f.input(:body, label: "Body").to_s }
      form.to_s.must_equal %(<form method="post" class="form-inline" action="/questions/13"><div class="form-group"><label for="comment_body" class="control-label">Body</label><input name="comment[body]" id="comment_body" value="Something exciting" type="text" class="form-control"/></div></form>)
    end

    it "#outputs without block (use end)" do
      form = builder.form(action: "/questions/13", method: "put")
      html = form.to_s
      html << form.input(:body, label: "Body").to_s
      html << form.end

      html.must_equal %(<form method="put" class="form-inline" action="/questions/13"><div class="form-group"><label for="comment_body" class="control-label">Body</label><input name="comment[body]" id="comment_body" value="Something exciting" type="text" class="form-control"/></div></form>)
    end
  end
end
