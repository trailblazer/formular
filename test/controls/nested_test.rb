require "test_helper"

class NestedCollectionTest < Minitest::Spec
  let (:builder) { Formular::Builder.new(model: model) }

  let (:model) { Comment.new(nil, nil, [Reply.new, Reply.new]) }

  it do
    builder.nested(:replies) do |f|
      f.input(:id)
    end.must_eq %{<fieldset ><input type="text" name="replies[][id]" id="form_replies_0_id" value="" /><input type="text" name="replies[][id]" id="form_replies_1_id" value="" /></fieldset>}
  end

  describe "collection with nested objects" do
    let (:model) { Comment.new([Comment.new(1, nil, [Reply.new(2), Reply.new(3)])]) }

    it do
      builder.nested(:id) do |cmt| # id is [Comment].
        #cmt.input(:id)
        cmt.nested(:replies) do |r|
          r.input(:id)
        end
      end.must_eq %{<fieldset ><fieldset >
<input type="text" name="id[][replies][][id]" id="form_id_0_replies_0_id" value="2" />
<input type="text" name="id[][replies][][id]" id="form_id_0_replies_1_id" value="3" />
</fieldset></fieldset>}
    end
  end

  describe "empty collection" do
    let (:model) { Comment.new(nil, nil, []) }

    it "no fieldset if empty" do
      builder.nested(:replies) do |f|
        f.input(:id)
      end.must_equal nil
    end
  end
end

class NestedSingularTest < Minitest::Spec
  let (:builder) { Formular::Builder.new(model: model) }
  let (:model) { Comment.new(nil, nil, nil, nil, nil, nil, Owner.new) }

  it do
    builder.nested(:owner, collection: false) do |f|
      f.input(:id)
    end.must_eq %{<fieldset ><input type="text" name="owner[id]" id="form_owner_id" value="" /></fieldset>}
  end

  describe "empty object" do
    let (:model) { Comment.new }

    # TODO: handle nil
    it do
      builder.nested(:owner, collection: false) do |f|
        f.input(:id)
      end.must_equal nil
    end
  end
end
