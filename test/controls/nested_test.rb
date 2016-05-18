require "test_helper"

class NestedTest < Minitest::Spec
  let (:builder) { Formular::Builder.new(model: model) }

  describe "#nested collection: true" do
    let (:model) { Comment.new(nil, nil, [Reply.new, Reply.new]) }

    it do
      builder.nested(:replies) do |f|
        f.input(:id)
      end.must_eq %{<fieldset ><input type="text" name="replies[][id]" id="form_replies_0_id" value="" /><input type="text" name="replies[][id]" id="form_replies_1_id" value="" /></fieldset>}
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

  describe "#nested collection: false (singular object)" do
    let (:model) { Comment.new(nil, nil, nil, nil, nil, nil, Owner.new) }

    it do
      builder.nested(:owner, collection: false) do |f|
        f.input(:id)
      end.must_eq %{<fieldset ><input type="text" name="owner[id]" id="form_owner_id" value="" /></fieldset>}
    end

    describe "empty object" do
      let (:model) { Comment.new }

      # TODO: handle nil
    end
  end

end
