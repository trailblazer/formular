require "test_helper"

class FormularTest < Minitest::Spec
  let (:model) { Comment.new(nil, "Amazing!", [Reply.new]) }
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

  describe "#textarea" do
    it { builder.textarea(:body).must_equal %{<textarea name="body" type="text" id="form_body">Amazing!</textarea>} }
    # nil content still makes closing tag.
    it { builder.textarea(:id).must_equal %{<textarea name="id" type="text" id="form_id"></textarea>} }
  end

  describe "#checkbox" do
    describe "unchecked" do
      it { builder.checkbox(:public).must_equal %{<input type="hidden" value="0" name="public" /><input name="public" type="checkbox" value="1" id="form_public" />} }
    end

    describe "checked!" do
      let (:model) { Comment.new(nil, nil, nil, nil, 1) }
      it { builder.checkbox(:public).must_equal %{<input type="hidden" value="0" name="public" /><input name="public" type="checkbox" value="1" id="form_public" checked="checked" />} }
    end

    describe ":label" do
      it { builder.checkbox(:public, label: "Public?").must_equal %{<input type="hidden" value="0" name="public" /><input name="public" type="checkbox" value="1" id="form_public" /><label for="form_public">Public?</label>} }
    end
  end

  describe "#radio" do
    describe "unchecked" do
      it { builder.radio(:public, value: 9).must_equal %{<input name="public" type="radio" value="9" id="form_public_9" />} }
    end

    describe "checked!" do
      let (:model) { Comment.new(nil, nil, nil, nil, 9) }
      it { builder.radio(:public, value: 9).must_equal %{<input name="public" type="radio" value="9" id="form_public_9" checked="checked" />} }
    end

    describe ":label" do
      it { builder.radio(:public, value: 9, label: "Public?").must_equal %{<input name="public" type="radio" value="9" id="form_public_9" /><label for="form_public_9">Public?</label>} }
    end
  end

  describe "#collection" do
    let (:model) { Comment.new(nil, nil, nil, nil, 3) }

    it do
      builder.collection :public, [[:One, 1],[:Two, 2],[:Three, 3]] do |r, mdl|
        r.radio(:public, value: mdl.last, label: mdl.first)
      end.must_equal %{<input name="public" type="radio" value="1" id="form_public_1" /><label for="form_public_1">One</label><input name="public" type="radio" value="2" id="form_public_2" /><label for="form_public_2">Two</label><input name="public" type="radio" value="3" id="form_public_3" checked="checked" /><label for="form_public_3">Three</label>}
    end
  end

  describe "#select" do

  end
end
