require "test_helper"
require "formular/frontend/bootstrap3"

class Bootstrap3InputGroupTest < Minitest::Spec
  let (:model) { Comment.new(nil, nil, [Reply.new]) }
  let (:builder) { Formular::Bootstrap3::Builder.new(model: model) }

  describe "InputGroup" do
    it "basic content left" do
      builder.input(:id, input_group: { left: { content: "@" } }).must_eq %{
<div class="form-group">
<div class="input-group">
<span class="input-group-addon">@</span>
<input type="text" name="id" id="form_id" class="form-control" value="" />
</div>
</div>}
    end

    it "basic content right" do
      builder.input(:id, input_group: { right: { content: "@" } }).must_eq %{
<div class="form-group">
<div class="input-group">
<input type="text" name="id" id="form_id" class="form-control" value="" />
<span class="input-group-addon">@</span>
</div>
</div>}
    end

    it "basic content both" do
      builder.input(:id, input_group: { left: {content: "@@" }, right: { content: "@" } }).must_eq %{
<div class="form-group">
<div class="input-group">
<span class="input-group-addon">@@</span>
<input type="text" name="id" id="form_id" class="form-control" value="" />
<span class="input-group-addon">@</span>
</div>
</div>}
    end

    it "with input group wrapper attributes" do
      builder.input(:id, input_group: { right: { content: "@" }, attrs: { class: ["input-wrapper"], id: "unique", 'data-options': "something good" }}).must_eq %{
<div class="form-group">
<div class="input-group input-wrapper" id="unique" data-options="something good">
<input type="text" name="id" id="form_id" class="form-control" value="" />
<span class="input-group-addon">@</span>
</div>
</div>}
    end


    it "with HTML content" do
      builder.input(:id, input_group: { right: { content: "<span class='glyphicon glyphicon-tick'></span>" } }).must_eq %{
<div class="form-group">
<div class="input-group">
<input type="text" name="id" id="form_id" class="form-control" value="" />
<span class="input-group-addon"><span class='glyphicon glyphicon-tick'></span></span>
</div>
</div>}
    end


    it "with button as content" do
      builder.input(:id, input_group: { right: { content: "<button class='btn btn-default' type='button'>Go!</button>", button: true } }).must_eq %{
<div class="form-group">
<div class="input-group">
<input type="text" name="id" id="form_id" class="form-control" value="" />
<span class="input-group-btn"><button class='btn btn-default' type='button'>Go!</button></span>
</div>
</div>}
    end

    it "with control as content" do
      builder.input(:id, input_group: { right: { content: builder.radio(:public, value: 1, inline: true) } }).must_eq %{
<div class="form-group">
<div class="input-group">
<input type="text" name="id" id="form_id" class="form-control" value="" />
<span class="input-group-addon"><input type="radio" value="1" name="public" id="form_public_1" /></span>
</div>
</div>}
    end


    it "with error" do
      builder.input(:id, input_group: { right: { content: "@" } }, error: ["wrong@!"]).must_eq %{
<div class="form-group has-error">
<div class="input-group">
<input type="text" name="id" id="form_id" class="form-control" value="" />
<span class="input-group-addon">@</span>
</div>
<span class="help-block">["wrong@!"]</span>
</div>}
    end

    it "with hint" do
      builder.input(:id, input_group: { right: { content: "@" } }, hint: "Handy help text").must_eq %{
<div class="form-group">
<div class="input-group">
<input type="text" name="id" id="form_id" class="form-control" value="" />
<span class="input-group-addon">@</span>
</div>
<span class="help-block">Handy help text</span>
</div>}
    end


    it "with label" do
      builder.input(:id, input_group: { right: { content: "@" } } , label: "ID").must_eq %{
<div class="form-group">
<label class="control-label" for="form_id">ID</label>
<div class="input-group">
<input type="text" name="id" id="form_id" class="form-control" value="" />
<span class="input-group-addon">@</span>
</div>
</div>}
    end

    it "with horizontal form" do
      builder.input(:id, style: :horizontal, label: "ID", column_attrs: { label_class: ["col-sm-2"], input_class: ["col-sm-10"]}, input_group: { right: { content: "@" } }).must_eq %{
<div class="form-group">
<label class="control-label col-sm-2" for="form_id">ID</label>
<div class="col-sm-10">
<div class="input-group">
<input type="text" name="id" id="form_id" class="form-control" value="" />
<span class="input-group-addon">@</span>
</div>
</div>
</div>}
    end
  end

end