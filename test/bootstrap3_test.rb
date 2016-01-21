require "test_helper"
require "formular/frontend/bootstrap3"

class Bootstrap3Test < Minitest::Spec
  let (:model) { Comment.new(nil, nil, [Reply.new]) }
  let (:builder) { Formular::Bootstrap3::Builder.new(model: model) }

  describe "#input" do
    it { builder.input(:id, label: "Id").gsub("\n", "").must_equal %{
<div class="form-group">
<label for="form_id">Id</label>
<input name="id" type="text" id="form_id" class="form-group" value="" />
</div>}.gsub("\n", "") }

    it { builder.input(:id).must_equal                        %{<input name="id" type="text" id="form_id" value="" />} }

    describe "with errors" do
      let (:model) { Comment.new(nil, nil, [Reply.new], nil, nil, {id: ["wrong!"]}) }

      it { builder.input(:id).must_equal %{<input class="error" name="id" type="text" id="form_id" value="" /><small class="error">["wrong!"]</small>} }
      it { builder.input(:id, label: "Id").must_equal %{<label >Id<input class="error" name="id" type="text" id="form_id" value="" /></label><small class="error">["wrong!"]</small>} }
    end
  end

  describe "#checkbox" do
    describe "unchecked" do
      it { builder.checkbox(:public, label: "Public?").must_equal %{<input type="hidden" value="0" name="public" /><input name="public" type="checkbox" id="form_public_1" value="1" /><label for="form_public_1">Public?</label>} }
      it { builder.checkbox(:public).must_equal %{<input type="hidden" value="0" name="public" /><input name="public" type="checkbox" id="form_public_1" value="1" />} }
    end

    describe "with errors" do

    end
  end
end
