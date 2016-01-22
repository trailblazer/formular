require "test_helper"
require "formular/frontend/bootstrap3"

class Bootstrap3Test < Minitest::Spec
  let (:model) { Comment.new(nil, nil, [Reply.new]) }
  let (:builder) { Formular::Bootstrap3::Builder.new(model: model) }

  describe "#input" do
    # with label.
    it { builder.input(:id, label: "Id").must_eq %{
<div class="form-group">
<label for="form_id">Id</label>
<input name="id" type="text" id="form_id" class="form-control" value="" />
</div>} }

    # no options.
    it { builder.input(:id).must_eq %{
<div class="form-group">
<input name="id" type="text" id="form_id" class="form-control" value="" />
</div>} }

    describe "with errors" do
      let (:model) { Comment.new(nil, nil, [Reply.new], nil, nil, {id: ["wrong!"]}) }

      it { builder.input(:id).must_eq %{
<div class="form-group has-error">
<input name="id" type="text" id="form_id" class="form-control" value="" />
<span class="help-block">[\"wrong!\"]</span>
</div>} }
      it { builder.input(:id, label: "Id").must_eq %{
<div class="form-group has-error">
<label for="form_id">Id</label>
<input name="id" type="text" id="form_id" class="form-control" value="" />
<span class="help-block">[\"wrong!\"]</span>
</div>
} }
    end
  end

# <div class="checkbox">
#   <label>
#     <input type="checkbox" value="">
#     Option one is this and that&mdash;be sure to include why it's great
#   </label>
# </div>

  describe "#checkbox" do
    describe "stacked (default)" do
      it { builder.checkbox(:public, label: "Public?").must_eq %{
<div class="checkbox">
<label >
<input type="hidden" value="0" name="public" />
<input name="public" type="checkbox" id="form_public_1" value="1" />
Public?
</label>
</div>
}
      }

      # TODO: more classes
      # <div class="checkbox disabled">
      #   <label>
      #     <input type="checkbox" value="" disabled>
      #     Option two is disabled
      #   </label>
      # </div>
    end

    describe "unchecked" do
      it { builder.checkbox(:public, label: "Public?").must_equal %{<input type="hidden" value="0" name="public" /><input name="public" type="checkbox" id="form_public_1" value="1" /><label for="form_public_1">Public?</label>} }
      it { builder.checkbox(:public).must_equal %{<input type="hidden" value="0" name="public" /><input name="public" type="checkbox" id="form_public_1" value="1" />} }
    end

    describe "with errors" do

    end
  end
end
