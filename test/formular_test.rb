require "test_helper"

class FormularTest < Minitest::Spec
  let (:model) { Comment.new(nil, nil, [Reply.new]) }
  let (:builder) { Formular::Builder.new(model: model) }

  describe "id" do
    it { builder.input(:id).must_equal %{<input name="id" type="text" value="" id="form_id" />} }
    # allow id off.
    it { builder.input(:id, id: false).must_equal %{<input name="id" type="text" value="" />} }
    # allow manual id.
    it { builder.input(:id, id: "false").must_equal %{<input name="id" type="text" value="" id="false" />} }

    it do
      builder.nested(:replies) do |f|
        f.input(:id)
      end.must_equal %{<fieldset><input name="replies[id]" type="text" value="" id="form_replies_0_id" /></fieldset>}
    end
  end

  describe "#nested" do
    let (:model) { Comment.new(nil, nil, [Reply.new, Reply.new]) }

    it do
      builder.nested(:replies) do |f|
        f.input(:id)
      end.must_equal %{<fieldset><input name="replies[id]" type="text" value="" id="form_replies_0_id" /><input name="replies[id]" type="text" value="" id="form_replies_1_id" /></fieldset>}
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
end
