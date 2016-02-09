require "test_helper"
require "formular/frontend/bootstrap3"

class Bootstrap3HorizontalFormTest < Minitest::Spec
  let (:model) { Comment.new(nil, nil, [Reply.new]) }
  let (:builder) { Formular::Bootstrap3::Builder.new(model: model) }

  describe "#form style: :horizontal" do
    it { builder.form(style: :horizontal){}.must_eq %{<form class="form-horizontal" />} }
    it { builder.form(style: :horizontal, class: [:bright]){}.must_eq %{<form class="form-horizontal bright" />} }

    describe "#input" do
      it "without Label" do
        builder.input(:id, style: :horizontal, column_attrs: { input_class: ["col-sm-offset-2", "col-sm-10"]} ).must_eq %{
<div class="form-group">
<div class="col-sm-offset-2 col-sm-10"><input type="text" name="id" id="form_id" class="form-control" value="" /></div>
</div>}
      end
      it do
        builder.input(:id, style: :horizontal, label: "ID", column_attrs: { label_class: ["col-sm-2"], input_class: ["col-sm-10"]} ).must_eq %{
<div class="form-group">
<label class="control-label col-sm-2" for="form_id">ID</label>
<div class="col-sm-10"><input type="text" name="id" id="form_id" class="form-control" value="" /></div>
</div>}
      end

      describe "with errors" do
        it { builder.input(:id, style: :horizontal, label: "ID", error: ["wrong@!"], column_attrs: { label_class: ["col-sm-2"], input_class: ["col-sm-10"]} ).must_eq %{
<div class="form-group has-error">
<label class="control-label col-sm-2" for="form_id">ID</label>
<div class="col-sm-10">
<input type="text" name="id" id="form_id" class="form-control" value="" />
<span class="help-block">["wrong@!"]</span>
</div>
</div>} }
      end
      describe "with hint" do
        it { builder.input(:id, style: :horizontal, label: "ID", hint: "Handy help text", column_attrs: { label_class: ["col-sm-2"], input_class: ["col-sm-10"]} ).must_eq %{
<div class="form-group">
<label class="control-label col-sm-2" for="form_id">ID</label>
<div class="col-sm-10">
<input type="text" name="id" id="form_id" class="form-control" value="" />
<span class="help-block">Handy help text</span>
</div>
</div>} }
      end
    end

    describe "#textarea" do
      it "without label" do
        builder.textarea(:public, style: :horizontal, column_attrs: { input_class: ["col-sm-offset-2", "col-sm-10"]} ).must_eq %{
<div class="form-group">
<div class="col-sm-offset-2 col-sm-10"><textarea name="public" id="form_public" class="form-control"></textarea></div>
</div>}
      end
      it do
        builder.textarea(:public, style: :horizontal, label: "Public", column_attrs: { label_class: ["col-sm-2"], input_class: ["col-sm-10"]} ).must_eq %{
<div class="form-group">
<label class="control-label col-sm-2" for="form_public">Public</label>
<div class="col-sm-10"><textarea name="public" id="form_public" class="form-control"></textarea></div>
</div>}
      end

      describe "with errors" do
        it { builder.textarea(:public, style: :horizontal, label: "Public", error: ["wrong@!"], column_attrs: { label_class: ["col-sm-2"], input_class: ["col-sm-10"]} ).must_eq %{
<div class="form-group has-error">
<label class="control-label col-sm-2" for="form_public">Public</label>
<div class="col-sm-10">
<textarea name="public" id="form_public" class="form-control"></textarea>
<span class="help-block">["wrong@!"]</span>
</div>
</div>} }
      end
      describe "with hint" do
        it { builder.textarea(:public, style: :horizontal, label: "Public", hint: "Handy help text", column_attrs: { label_class: ["col-sm-2"], input_class: ["col-sm-10"]} ).must_eq %{
<div class="form-group">
<label class="control-label col-sm-2" for="form_public">Public</label>
<div class="col-sm-10">
<textarea name="public" id="form_public" class="form-control"></textarea>
<span class="help-block">Handy help text</span>
</div>
</div>} }
      end
    end
    describe "collection type: :select" do
      it "without label" do
        builder.collection(:public, [[:One, 1],[:Two, 2],[:Three, 3]], selected: [2], type: :select, style: :horizontal, column_attrs: { input_class: ["col-sm-offset-2", "col-sm-10"]}).must_eq %{
<div class="form-group">
<div class="col-sm-offset-2 col-sm-10">
<select name="public" id="form_public" class="form-control">
<option value="1">One</option>
<option value="2" selected="true">Two</option>
<option value="3">Three</option>
</select>
</div>
</div>}
      end
      it do
        builder.collection(:public, [[:One, 1],[:Two, 2],[:Three, 3]], selected: [2], type: :select, style: :horizontal, label: "Public", column_attrs: { label_class: ["col-sm-2"], input_class: ["col-sm-10"]}).must_eq %{
<div class="form-group">
<label class="control-label col-sm-2" for="form_public">Public</label>
<div class="col-sm-10">
<select name="public" id="form_public" class="form-control">
<option value="1">One</option>
<option value="2" selected="true">Two</option>
<option value="3">Three</option>
</select>
</div>
</div>}
      end

      describe "with errors" do
        it do
          builder.collection(:public, [[:One, 1],[:Two, 2],[:Three, 3]], selected: [2], type: :select, style: :horizontal, label: "Public", error: ["wrong@!"], column_attrs: { label_class: ["col-sm-2"], input_class: ["col-sm-10"]}).must_eq %{
<div class="form-group has-error">
<label class="control-label col-sm-2" for="form_public">Public</label>
<div class="col-sm-10">
<select name="public" id="form_public" class="form-control">
<option value="1">One</option>
<option value="2" selected="true">Two</option>
<option value="3">Three</option>
</select>
<span class="help-block">["wrong@!"]</span>
</div>
</div>}
        end
      end

      describe "with hint" do
        it do
          builder.collection(:public, [[:One, 1],[:Two, 2],[:Three, 3]], selected: [2], type: :select, style: :horizontal, label: "Public", hint: "Handy help text", column_attrs: { label_class: ["col-sm-2"], input_class: ["col-sm-10"]}).must_eq %{
<div class="form-group">
<label class="control-label col-sm-2" for="form_public">Public</label>
<div class="col-sm-10">
<select name="public" id="form_public" class="form-control">
<option value="1">One</option>
<option value="2" selected="true">Two</option>
<option value="3">Three</option>
</select>
<span class="help-block">Handy help text</span>
</div>
</div>}
        end
      end
    end

    describe "collection type: :checkbox" do
      it "without label" do
        builder.collection(:public, [[:One, 1],[:Two, 2],[:Three, 3]], type: :checkbox, checked: [2,3], style: :horizontal, column_attrs: { input_class: ["col-sm-offset-2","col-sm-10"]}).must_eq %{
<div class="form-group">
<div class="col-sm-offset-2 col-sm-10">
<div class="checkbox"><label ><input type="checkbox" value="1" name="public[]" id="form_public_1" />One</label></div>
<div class="checkbox"><label ><input type="checkbox" value="2" checked="true" name="public[]" id="form_public_2" />Two</label></div>
<div class="checkbox"><label ><input type="hidden" value="0" name="public[]" /><input type="checkbox" value="3" checked="true" name="public[]" id="form_public_3" />Three</label></div>
</div>
</div>}
      end

      it do
        # TODO: allow merging :class!
        builder.collection(:public, [[:One, 1],[:Two, 2],[:Three, 3]], type: :checkbox, checked: [2,3], style: :horizontal, label: "One!", column_attrs: { label_class: ["col-sm-2"], input_class: ["col-sm-10"]}).must_eq %{
<div class="form-group">
<label class="control-label col-sm-2">One!</label>
<div class="col-sm-10">
<div class="checkbox"><label ><input type="checkbox" value="1" name="public[]" id="form_public_1" />One</label></div>
<div class="checkbox"><label ><input type="checkbox" value="2" checked="true" name="public[]" id="form_public_2" />Two</label></div>
<div class="checkbox"><label ><input type="hidden" value="0" name="public[]" /><input type="checkbox" value="3" checked="true" name="public[]" id="form_public_3" />Three</label></div>
</div>
</div>}
      end
      describe "inline: true" do
        it do
          builder.collection(:public, [[:One, 1],[:Two, 2],[:Three, 3]], type: :checkbox, checked: [2,3], style: :horizontal, label: "One!", inline: true, column_attrs: { label_class: ["col-sm-2"], input_class: ["col-sm-10"]}).must_eq %{
<div class="form-group">
<label class="control-label col-sm-2">One!</label>
<div class="col-sm-10">
<label class="checkbox-inline"><input type="checkbox" value="1" name="public[]" id="form_public_1" />One</label>
<label class="checkbox-inline"><input type="checkbox" value="2" checked="true" name="public[]" id="form_public_2" />Two</label>
<label class="checkbox-inline"><input type="hidden" value="0" name="public[]" />
<input type="checkbox" value="3" checked="true" name="public[]" id="form_public_3" />Three</label>
</div>
</div>
}
        end
      end
      describe "with errors" do
        it do
          builder.collection(:public, [[:One, 1],[:Two, 2],[:Three, 3]], type: :checkbox, checked: [2,3], style: :horizontal, label: "One!", error: ["wrong@!"], column_attrs: { label_class: ["col-sm-2"], input_class: ["col-sm-10"]}).must_eq %{
<div class="form-group has-error">
<label class="control-label col-sm-2">One!</label>
<div class="col-sm-10">
<div class="checkbox"><label ><input type="checkbox" value="1" name="public[]" id="form_public_1" />One</label></div>
<div class="checkbox"><label ><input type="checkbox" value="2" checked="true" name="public[]" id="form_public_2" />Two</label></div>
<div class="checkbox"><label ><input type="hidden" value="0" name="public[]" /><input type="checkbox" value="3" checked="true" name="public[]" id="form_public_3" />Three</label></div>
<span class="help-block">["wrong@!"]</span>
</div>
</div>}
        end
      end

      describe "with hint" do
        it do
          builder.collection(:public, [[:One, 1],[:Two, 2],[:Three, 3]], type: :checkbox, checked: [2,3], style: :horizontal, label: "One!", hint: "Handy help text", column_attrs: { label_class: ["col-sm-2"], input_class: ["col-sm-10"]}).must_eq %{
<div class="form-group">
<label class="control-label col-sm-2">One!</label>
<div class="col-sm-10">
<div class="checkbox"><label ><input type="checkbox" value="1" name="public[]" id="form_public_1" />One</label></div>
<div class="checkbox"><label ><input type="checkbox" value="2" checked="true" name="public[]" id="form_public_2" />Two</label></div>
<div class="checkbox"><label ><input type="hidden" value="0" name="public[]" /><input type="checkbox" value="3" checked="true" name="public[]" id="form_public_3" />Three</label></div>
<span class="help-block">Handy help text</span>
</div>
</div>}
        end
        it "and error" do
          builder.collection(:public, [[:One, 1],[:Two, 2],[:Three, 3]], type: :checkbox, checked: [2,3], style: :horizontal, label: "One!", hint: "Handy help text", error: ["wrong@!"], column_attrs: { label_class: ["col-sm-2"], input_class: ["col-sm-10"]}).must_eq %{
<div class="form-group has-error">
<label class="control-label col-sm-2">One!</label>
<div class="col-sm-10">
<div class="checkbox"><label ><input type="checkbox" value="1" name="public[]" id="form_public_1" />One</label></div>
<div class="checkbox"><label ><input type="checkbox" value="2" checked="true" name="public[]" id="form_public_2" />Two</label></div>
<div class="checkbox"><label ><input type="hidden" value="0" name="public[]" /><input type="checkbox" value="3" checked="true" name="public[]" id="form_public_3" />Three</label></div>
<span class="help-block">Handy help text</span>
<span class="help-block">["wrong@!"]</span>
</div>
</div>}
        end
      end
    end

    describe "collection type: :radio" do
      it "without label" do
        # TODO: allow merging :class!
        builder.collection(:public, [[:One, 1],[:Two, 2],[:Three, 3]], type: :radio, checked: [2,3], style: :horizontal, column_attrs: { input_class: ["col-sm-offset-2","col-sm-10"]}).must_eq %{
<div class="form-group">
<div class="col-sm-offset-2 col-sm-10">
<div class="radio"><label ><input type="radio" value="1" name="public" id="form_public_1" />One</label></div>
<div class="radio"><label ><input type="radio" value="2" checked="true" name="public" id="form_public_2" />Two</label></div>
<div class="radio"><label ><input type="radio" value="3" checked="true" name="public" id="form_public_3" />Three</label></div>
</div>
</div>}
      end

      it do
        # TODO: allow merging :class!
        builder.collection(:public, [[:One, 1],[:Two, 2],[:Three, 3]], type: :radio, checked: [2,3], style: :horizontal, label: "One!", column_attrs: { label_class: ["col-sm-2"], input_class: ["col-sm-10"]}).must_eq %{
<div class="form-group">
<label class="control-label col-sm-2">One!</label>
<div class="col-sm-10">
<div class="radio"><label ><input type="radio" value="1" name="public" id="form_public_1" />One</label></div>
<div class="radio"><label ><input type="radio" value="2" checked="true" name="public" id="form_public_2" />Two</label></div>
<div class="radio"><label ><input type="radio" value="3" checked="true" name="public" id="form_public_3" />Three</label></div>
</div>
</div>}
      end
      describe "inline: true" do
        it do
          builder.collection(:public, [[:One, 1],[:Two, 2],[:Three, 3]], type: :radio, checked: [2,3], style: :horizontal, label: "One!", inline: true, column_attrs: { label_class: ["col-sm-2"], input_class: ["col-sm-10"]}).must_eq %{
<div class="form-group">
<label class="control-label col-sm-2">One!</label>
<div class="col-sm-10">
<label class="radio-inline"><input type="radio" value="1" name="public" id="form_public_1" />One</label>
<label class="radio-inline"><input type="radio" value="2" checked="true" name="public" id="form_public_2" />Two</label>
<label class="radio-inline"><input type="radio" value="3" checked="true" name="public" id="form_public_3" />Three</label>
</div>
</div>}
        end
      end
      describe "with errors" do
        it do
          builder.collection(:public, [[:One, 1],[:Two, 2],[:Three, 3]], type: :radio, checked: [2,3], style: :horizontal, label: "One!", inline: true, error: ["wrong@!"], column_attrs: { label_class: ["col-sm-2"], input_class: ["col-sm-10"]}).must_eq %{
<div class="form-group has-error">
<label class="control-label col-sm-2">One!</label>
<div class="col-sm-10">
<label class="radio-inline"><input type="radio" value="1" name="public" id="form_public_1" />One</label>
<label class="radio-inline"><input type="radio" value="2" checked="true" name="public" id="form_public_2" />Two</label>
<label class="radio-inline"><input type="radio" value="3" checked="true" name="public" id="form_public_3" />Three</label>
<span class="help-block">["wrong@!"]</span>
</div>
</div>}
        end
      end

      describe "with hint" do
        it do
          builder.collection(:public, [[:One, 1],[:Two, 2],[:Three, 3]], type: :radio, checked: [2,3], style: :horizontal, label: "One!", inline: true, hint: "Handy help text", column_attrs: { label_class: ["col-sm-2"], input_class: ["col-sm-10"]}).must_eq %{
<div class="form-group">
<label class="control-label col-sm-2">One!</label>
<div class="col-sm-10">
<label class="radio-inline"><input type="radio" value="1" name="public" id="form_public_1" />One</label>
<label class="radio-inline"><input type="radio" value="2" checked="true" name="public" id="form_public_2" />Two</label>
<label class="radio-inline"><input type="radio" value="3" checked="true" name="public" id="form_public_3" />Three</label>
<span class="help-block">Handy help text</span>
</div>
</div>}
        end
        it "and error" do
          builder.collection(:public, [[:One, 1],[:Two, 2],[:Three, 3]], type: :radio, checked: [2,3], style: :horizontal, label: "One!", inline: true, column_attrs: { label_class: ["col-sm-2"], input_class: ["col-sm-10"]}, hint: "Handy help text", error: ["wrong@!"]).must_eq %{
<div class="form-group has-error">
<label class="control-label col-sm-2">One!</label>
<div class="col-sm-10">
<label class="radio-inline"><input type="radio" value="1" name="public" id="form_public_1" />One</label>
<label class="radio-inline"><input type="radio" value="2" checked="true" name="public" id="form_public_2" />Two</label>
<label class="radio-inline"><input type="radio" value="3" checked="true" name="public" id="form_public_3" />Three</label>
<span class="help-block">Handy help text</span>
<span class="help-block">["wrong@!"]</span>
</div>
</div>}
        end
      end
    end
  end
end