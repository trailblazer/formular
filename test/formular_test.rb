require "test_helper"

class FormularTest < Minitest::Spec
  let (:model) { Comment.new(nil, "Amazing!", [Reply.new]) }
  let (:builder) { Formular::Builder.new(model: model) }

  describe "id" do
    it { builder.input(:id).must_equal %{<input name="id" type="text" id="form_id" value="" />} }
    # allow id off.
    it { builder.input(:id, id: false).must_equal %{<input name="id" type="text" value="" />} }
    # allow manual id.
    it { builder.input(:id, id: "false").must_equal %{<input name="id" type="text" id="false" value="" />} }

    it do
      builder.nested(:replies) do |f|
        f.input(:id)
      end.must_equal %{<fieldset><input name="replies[id]" type="text" id="form_replies_0_id" value="" /></fieldset>}
    end
  end

  describe "#nested" do
    let (:model) { Comment.new(nil, nil, [Reply.new, Reply.new]) }

    it do
      builder.nested(:replies) do |f|
        f.input(:id)
      end.must_equal %{<fieldset><input name="replies[id]" type="text" id="form_replies_0_id" value="" /><input name="replies[id]" type="text" id="form_replies_1_id" value="" /></fieldset>}
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
    it { builder.textarea(:body).must_equal %{<textarea name="body" id="form_body">Amazing!</textarea>} }
    # nil content still makes closing tag.
    it { builder.textarea(:id).must_equal %{<textarea name="id" id="form_id"></textarea>} }
  end

  describe "#checkbox" do
    describe "unchecked" do
      it { builder.checkbox(:public).must_equal %{<input type="hidden" value="0" name="public" /><input name="public" type="checkbox" id="form_public_1" value="1" />} }
    end

    describe "implicitly checked" do
      let (:model) { Comment.new(nil, nil, nil, nil, 1) }
      it { builder.checkbox(:public).must_equal %{<input type="hidden" value="0" name="public" /><input name="public" type="checkbox" id="form_public_1" value="1" checked="checked" />} }
    end

    describe "explicitly :checked" do
      it { builder.checkbox(:public, checked: true).must_equal %{<input type="hidden" value="0" name="public" /><input name="public" type="checkbox" checked="true" id="form_public_1" value="1" />} }
      # false/nil will NOT render the checked attribute.
      it { builder.checkbox(:public, checked: false).must_equal %{<input type="hidden" value="0" name="public" /><input name="public" type="checkbox" id="form_public_1" value="1" />} }
      it { builder.checkbox(:public, checked: nil).must_equal   %{<input type="hidden" value="0" name="public" /><input name="public" type="checkbox" id="form_public_1" value="1" />} }
    end

    describe ":label" do
      it { builder.checkbox(:public, label: "Public?").must_equal %{<input type="hidden" value="0" name="public" /><input name="public" type="checkbox" id="form_public_1" value="1" /><label for="form_public_1">Public?</label>} }
    end

    describe ":value/:unchecked_value" do
      it { builder.checkbox(:public, value: 2, unchecked_value: 3).must_equal %{<input type="hidden" value="3" name="public" /><input name="public" type="checkbox" value="2" id="form_public_2" />} }
    end
  end

  describe "#radio" do
    describe "unchecked" do
      it { builder.radio(:public, value: 9).must_equal %{<input name="public" type="radio" value="9" id="form_public_9" />} }
    end

    describe "implicitly checked" do
      let (:model) { Comment.new(nil, nil, nil, nil, 9) }
      it { builder.radio(:public, value: 9).must_equal %{<input name="public" type="radio" value="9" id="form_public_9" checked="checked" />} }
    end

    describe "explicitly checked" do
      let (:model) { Comment.new(nil, nil, nil, nil, 1) }
      it { builder.radio(:public, value: 1, checked: true).must_equal  %{<input name="public" type="radio" value="1" checked="true" id="form_public_1" />} }
      it { builder.radio(:public, value: 2, checked: true).must_equal  %{<input name="public" type="radio" value="2" checked="true" id="form_public_2" />} }
      it { builder.radio(:public, value: 1, checked: false).must_equal %{<input name="public" type="radio" value="1" id="form_public_1" />} }
    end

    describe ":label" do
      it { builder.radio(:public, value: 9, label: "Public?").must_equal %{<input name="public" type="radio" value="9" id="form_public_9" /><label for="form_public_9">Public?</label>} }
    end
  end

  describe "#collection" do
    let (:model) { Comment.new(nil, nil, nil, nil, 3) }

    describe "with radio" do
      # with last item "checked".
      it do
        # DISCUSS: allow checked: 1 here as well?
        builder.collection :public, [[:One, 1],[:Two, 2],[:Three, 3]] do |r, mdl|
          r.radio(:public, value: mdl.last, label: mdl.first, checked: (mdl==2))
        end.must_equal %{
<input name="public" type="radio" value="1" id="form_public_1" /><label for="form_public_1">One</label>
<input name="public" type="radio" value="2" id="form_public_2" checked="checked" /><label for="form_public_2">Two</label>
<input name="public" type="radio" value="3" id="form_public_3" /><label for="form_public_3">Three</label>}.gsub("\n", "")
      end
    end

    describe "with checkbox" do
      # it do
      #   builder.collection :public, [[:One, 1],[:Two, 2],[:Three, 3]], checked: [2,3] do |r, mdl|
      #     r.checkbox(:public, value: mdl.last, label: mdl.first)
      #   end.must_equal %{<input name="public" type="radio" value="1" id="form_public_1" /><label for="form_public_1">One</label><input name="public" type="radio" value="2" id="form_public_2" /><label for="form_public_2">Two</label><input name="public" type="radio" value="3" id="form_public_3" checked="checked" /><label for="form_public_3">Three</label>}
      # end

      it do
        builder.collection :public, [[:One, 1],[:Two, 2],[:Three, 3]] do |r, mdl|
          r.checkbox(:public, value: mdl.last, label: mdl.first, checked: (mdl == 2 or mdl == 3), skip_hidden: true)
        end.must_equal %{
<input name="public" type="checkbox" value="1" id="form_public_1" /><label for="form_public_1">One</label>
<input name="public" type="checkbox" value="2" id="form_public_2" checked="checked" /><label for="form_public_2">Two</label>
<input name="public" type="checkbox" value="3" id="form_public_3" checked="checked" /><label for="form_public_3">Three</label>}.gsub("\n", "")
      end
    end
  end

  describe "#select" do

  end
end
