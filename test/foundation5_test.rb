require "test_helper"
require "formular/frontend/foundation5"

class Foundation5Test < Minitest::Spec
  let (:model) { Comment.new(nil, nil, [Reply.new]) }
  let (:builder) { Formular::Foundation5::Builder.new(model: model) }

  describe "#input" do
    it { builder.input(:id, label: "Id").must_equal %{<label >Id<input type="text" name="id" id="form_id" value="" /></label>} }
    it { builder.input(:id).must_equal                        %{<input type="text" name="id" id="form_id" value="" />} }

    describe "with errors" do
      let (:model) { Comment.new(nil, nil, [Reply.new], nil, nil, {id: ["wrong!"]}) }

      it { builder.input(:id).must_equal %{<input class="error" type="text" name="id" id="form_id" value="" /><small class="error">["wrong!"]</small>} }
      it { builder.input(:id, label: "Id").must_equal %{<label >Id<input class="error" type="text" name="id" id="form_id" value="" /></label><small class="error">["wrong!"]</small>} }
    end
  end

  describe "#checkbox" do
    describe "unchecked" do
      it { builder.checkbox(:public, label: "Public?").must_equal %{<input type="hidden" value="0" name="public" /><input type="checkbox" name="public" id="form_public_1" value="1" /><label for="form_public_1">Public?</label>} }
      it { builder.checkbox(:public).must_equal %{<input type="hidden" value="0" name="public" /><input type="checkbox" name="public" id="form_public_1" value="1" />} }
    end

    describe "with errors" do

    end
  end

  describe "collection type: :checkbox" do
    it do
      # TODO: allow merging :class!
      builder.collection(:public, [[:One, 1],[:Two, 2],[:Three, 3]], type: :checkbox, checked: [2,3], label: "One!").must_eq %{
<label >One!</label>
<input type="checkbox" value="1" name="public[]" id="form_public_1" /><label for="form_public_1">One</label>
<input type="checkbox" value="2" checked="true" name="public[]" id="form_public_2" /><label for="form_public_2">Two</label>
<input type="hidden" value="0" name="public[]" />
<input type="checkbox" value="3" checked="true" name="public[]" id="form_public_3" /><label for="form_public_3">Three</label>}
    end

    describe "with errors" do
      let (:model) { Comment.new(nil, nil, [], nil, nil, {public: ["wrong!"]}) }

      it do
        builder.collection(:public, [[:One, 1],[:Two, 2],[:Three, 3]], type: :checkbox, checked: [2,3], label: "One!").must_eq %{
<label >One!</label>
<input type="checkbox" value="1" name="public[]" id="form_public_1" /><label for="form_public_1">One</label>
<input type="checkbox" value="2" checked="true" name="public[]" id="form_public_2" /><label for="form_public_2">Two</label>
<input type="hidden" value="0" name="public[]" />
<input type="checkbox" value="3" checked="true" name="public[]" id="form_public_3" /><label for="form_public_3">Three</label>
<small class="error">["wrong!"]</small>
}
      end
    end
  end

#   it do
#     # TODO: allow merging :class!
#     builder.collection(:public, [[:One, 1],[:Two, 2],[:Three, 3]], type: :checkbox, checked: [2,3]) do |model:, options:, index:, **|
#       builder.checkbox(:public, options.merge(label: false, class: [(index.even? ? :even : :odd)])) +
#         builder.label(model.first, for: options[:id], "data-action": :create)

#     end.must_equal %{
# <input name="public[]" type="checkbox" value="1" class="even" id="form_public_1" /><label content="One" for="form_public_1" data-action="create" />
# <input name="public[]" type="checkbox" value="2" checked="true" class="odd" id="form_public_2" /><label content="Two" for="form_public_2" data-action="create" />
# <input type="hidden" value="0" name="public[]" />
# <input name="public[]" type="checkbox" value="3" checked="true" class="even" id="form_public_3" /><label content="Three" for="form_public_3" data-action="create" />}
#     end
#   end
end


