require "test_helper"

class FormularTest < Minitest::Spec
  let (:model) { Comment.new(nil, "Amazing!", [Reply.new]) }
  let (:builder) { Formular::Builder.new(model: model) }

  # Builder-wide
  describe ":errors" do
    let (:builder) { Formular::Builder.new(model: model, errors: {id: ["too easy!"]}) }

    it do
      builder.input(:id).must_eq %{<input type="text" name="id" id="form_id" value="" /><span class="error">["too easy!"]</span>}
    end
  end

  describe ":type" do
    it do
      builder.input(:id, type: "file").must_eq %{<input type="file" name="id" id="form_id" value="" />}
    end
  end


  describe ":id" do
    it { builder.input(:id).must_eq %{<input type="text" name="id" id="form_id" value="" />} }
    # allow id off.
    it { builder.input(:id, id: false).must_eq %{<input type="text" name="id" value="" />} }
    # allow manual id.
    it { builder.input(:id, id: "false").must_eq %{<input type="text" name="id" id="false" value="" />} }

    it do
      builder.nested(:replies) do |f|
        f.input(:id)
      end.must_eq %{<fieldset ><input type="text" name="replies[][id]" id="form_replies_0_id" value="" /></fieldset>}
    end
  end

  describe ":error" do
    it { builder.input(:id, error: ["no!"]).must_eq %{<input type="text" name="id" id="form_id" value="" /><span class="error">["no!"]</span>} }
    it { builder.input(:id, error: false).must_eq %{<input type="text" name="id" id="form_id" value="" />} }

    describe "overwrites Builder#errors" do
      let (:builder) { Formular::Builder.new(model: model, errors: {id: ["too easy!"]}) }
      it { builder.input(:id, error: false).must_eq %{<input type="text" name="id" id="form_id" value="" />} }
    end
  end

  describe "wrapper: false" do

  end

  describe "label: " do
    it "ignores without :label" do
      builder.input(:id, label_attrs: { "remote-data": true }).must_eq %{
<input type="text" name="id" id="form_id" value="" />
}
    end

    it do
      builder.input(:id, label_attrs: { "remote-data": true, class: [:id] }, label: "Id").must_eq %{
<label remote-data="true" class="id" for="form_id">Id</label>
<input type="text" name="id" id="form_id" value="" />}
    end

    # with errors
    it do
      builder.input(:id, label_attrs: { "remote-data": true, class: [:id] }, label: "Id", error: ["wrong@!"]).must_eq %{
<label remote-data="true" class="id" for="form_id">Id</label>
<input type="text" name="id" id="form_id" value="" />
<span class="error">["wrong@!"]</span>}
    end
  end

  describe "attributes for input" do
    it { builder.input(:id, "data-remote": true).must_eq %{<input type="text" data-remote="true" name="id" id="form_id" value="" />} }
  end

  describe "#nested collection" do
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

  describe "#textarea" do
    it { builder.textarea(:body).must_eq %{<textarea name="body" id="form_body">Amazing!</textarea>} }
    # nil content still makes closing tag.
    it { builder.textarea(:id).must_eq %{<textarea name="id" id="form_id"></textarea>} }
  end

  describe "#checkbox" do
    describe "unchecked" do
      it { builder.checkbox(:public).must_eq %{<input type="hidden" value="0" name="public" /><input type="checkbox" name="public" id="form_public_1" value="1" />} }
    end

    describe "implicitly checked" do
      let (:model) { Comment.new(nil, nil, nil, nil, 1) }
      it { builder.checkbox(:public).must_eq %{<input type="hidden" value="0" name="public" /><input type="checkbox" name="public" id="form_public_1" value="1" checked="checked" />} }
    end

    describe "explicitly :checked" do
      it { builder.checkbox(:public, checked: true).must_eq %{<input type="hidden" value="0" name="public" /><input type="checkbox" checked="true" name="public" id="form_public_1" value="1" />} }
      # false/nil will NOT render the checked attribute.
      it { builder.checkbox(:public, checked: false).must_eq %{<input type="hidden" value="0" name="public" /><input type="checkbox" name="public" id="form_public_1" value="1" />} }
      it { builder.checkbox(:public, checked: nil).must_eq   %{<input type="hidden" value="0" name="public" /><input type="checkbox" name="public" id="form_public_1" value="1" />} }
    end

    describe ":label" do
      it { builder.checkbox(:public, label: "Public?").must_eq %{<input type="hidden" value="0" name="public" /><input type="checkbox" name="public" id="form_public_1" value="1" /><label for="form_public_1">Public?</label>} }
    end

    describe ":value/:unchecked_value" do
      it { builder.checkbox(:public, value: 2, unchecked_value: 3).must_eq %{<input type="hidden" value="3" name="public" /><input type="checkbox" value="2" name="public" id="form_public_2" />} }
    end

    describe ":skip_suffix" do
      it { builder.checkbox(:public, skip_suffix: true).must_eq %{<input type="hidden" value="0" name="public" /><input type="checkbox" name="public" id="form_public" value="1" />} }
    end

    describe ":skip_hidden" do
      it { builder.checkbox(:public, skip_hidden: true).must_eq %{<input type="checkbox" name="public" id="form_public_1" value="1" />} }
    end
  end

  describe "#radio" do
    describe "unchecked" do
      it { builder.radio(:public, value: 9).must_eq %{<input type="radio" value="9" name="public" id="form_public_9" />} }
    end

    describe "implicitly checked" do
      let (:model) { Comment.new(nil, nil, nil, nil, 9) }
      it { builder.radio(:public, value: 9).must_eq %{<input type="radio" value="9" name="public" id="form_public_9" checked="checked" />} }
    end

    describe "explicitly checked" do
      let (:model) { Comment.new(nil, nil, nil, nil, 1) }
      it { builder.radio(:public, value: 1, checked: true).must_eq  %{<input type="radio" value="1" checked="true" name="public" id="form_public_1" />} }
      it { builder.radio(:public, value: 2, checked: true).must_eq  %{<input type="radio" value="2" checked="true" name="public" id="form_public_2" />} }
      it { builder.radio(:public, value: 1, checked: false).must_eq %{<input type="radio" value="1" name="public" id="form_public_1" />} }
    end

    describe ":label" do
      it { builder.radio(:public, value: 9, label: "Public?").must_eq %{<input type="radio" value="9" name="public" id="form_public_9" /><label for="form_public_9">Public?</label>} }
    end

    describe ":skip_suffix" do
      it { builder.radio(:public, skip_suffix: true, value: 1).must_eq %{<input type="radio" value="1" name="public" id="form_public" />} }
    end
  end

  describe "#collection" do
    let (:model) { Comment.new(nil, nil, nil, nil, 3) }

    describe "with radio" do
      # with last item "checked".
      it do
        # DISCUSS: allow checked: 1 here as well?
        builder.collection :public, [[:One, 1],[:Two, 2],[:Three, 3]] do |model:, **|
          builder.radio(:public, value: model.last, label: model.first, checked: (model.last==2))
        end.must_eq %{
<input type="radio" value="1" name="public" id="form_public_1" /><label for="form_public_1">One</label>
<input type="radio" value="2" checked="true" name="public" id="form_public_2" /><label for="form_public_2">Two</label>
<input type="radio" value="3" name="public" id="form_public_3" /><label for="form_public_3">Three</label>}
      end
    end

    describe "type: :radio, no block" do
      it do
        builder.collection(:public, [[:One, 1],[:Two, 2],[:Three, 3]], type: :radio, checked: [2]).must_eq %{
<input type="radio" value="1" name="public" id="form_public_1" /><label for="form_public_1">One</label>
<input type="radio" value="2" checked="true" name="public" id="form_public_2" /><label for="form_public_2">Two</label>
<input type="radio" value="3" name="public" id="form_public_3" /><label for="form_public_3">Three</label>
}
      end

      it "error:" do
        builder.collection(:public, [[:One, 1],[:Two, 2],[:Three, 3]], type: :radio, checked: [2], error: ["yes!"]).must_eq %{
<input type="radio" value="1" name="public" id="form_public_1" /><label for="form_public_1">One</label>
<input type="radio" value="2" checked="true" name="public" id="form_public_2" /><label for="form_public_2">Two</label>
<input type="radio" value="3" name="public" id="form_public_3" /><label for="form_public_3">Three</label>
<span class="error">["yes!"]</span>
}
      end

      it "checked: with string and integer" do
        builder.collection(:public, [[:One, 1],[:Two, 2]], type: :radio, checked: ["1",2]).must_eq %{
<input type="radio" value="1" checked="true" name="public" id="form_public_1" /><label for="form_public_1">One</label>
<input type="radio" value="2" checked="true" name="public" id="form_public_2" /><label for="form_public_2">Two</label>
}
      end

      it "no :checked" do
        builder.collection(:public, [[:One, 1],[:Two, 2]], type: :radio).must_eq %{
<input type="radio" value="1" name="public" id="form_public_1" /><label for="form_public_1">One</label>
<input type="radio" value="2" name="public" id="form_public_2" /><label for="form_public_2">Two</label>
}
      end

      it "checked: nil" do
        builder.collection(:public, [[:One, 1],[:Two, 2]], type: :radio, checked: nil).must_eq %{
<input type="radio" value="1" name="public" id="form_public_1" /><label for="form_public_1">One</label>
<input type="radio" value="2" name="public" id="form_public_2" /><label for="form_public_2">Two</label>
}
      end

      # no array passed to :checked.
      it "checked: 1" do
        builder.collection(:public, [[:One, 1],[:Two, 2]], type: :radio, checked: 2).must_eq %{
<input type="radio" value="1" name="public" id="form_public_1" /><label for="form_public_1">One</label>
<input type="radio" value="2" checked="true" name="public" id="form_public_2" /><label for="form_public_2">Two</label>
}
      end
    end

    describe "type: :checkbox, manual #checkbox" do
      it do
        builder.collection :public, [[:One, 1],[:Two, 2],[:Three, 3]] do |model:, **|
          builder.checkbox(:public, value: model.last, label: model.first, checked: (model.last == 2 or model.last == 3), skip_hidden: true)
        end.must_eq %{
<input type="checkbox" value="1" name="public" id="form_public_1" /><label for="form_public_1">One</label>
<input type="checkbox" value="2" checked="true" name="public" id="form_public_2" /><label for="form_public_2">Two</label>
<input type="checkbox" value="3" checked="true" name="public" id="form_public_3" /><label for="form_public_3">Three</label>}
      end
    end

    describe "type: :checkbox, no block" do
      it do
        builder.collection(:public, [[:One, 1],[:Two, 2],[:Three, 3]], type: :checkbox, checked: [2,3]).must_eq %{
<input type="checkbox" value="1" name="public[]" id="form_public_1" /><label for="form_public_1">One</label>
<input type="checkbox" value="2" checked="true" name="public[]" id="form_public_2" /><label for="form_public_2">Two</label>
<input type="hidden" value="0" name="public[]" />
<input type="checkbox" value="3" checked="true" name="public[]" id="form_public_3" /><label for="form_public_3">Three</label>}
      end

      it "error:" do
        builder.collection(:public, [[:One, 1],[:Two, 2],[:Three, 3]], type: :checkbox, checked: [2,3], error: ["no!"]).must_eq %{
<input type="checkbox" value="1" name="public[]" id="form_public_1" /><label for="form_public_1">One</label>
<input type="checkbox" value="2" checked="true" name="public[]" id="form_public_2" /><label for="form_public_2">Two</label>
<input type="hidden" value="0" name="public[]" />
<input type="checkbox" value="3" checked="true" name="public[]" id="form_public_3" /><label for="form_public_3">Three</label>
<span class="error">["no!"]</span>}
      end

      it "checked: with integer and string" do
        builder.collection(:public, [[:One, 1],[:Two, 2]], type: :checkbox, checked: [1, "2"]).must_eq %{
<input type="checkbox" value="1" checked="true" name="public[]" id="form_public_1" /><label for="form_public_1">One</label>
<input type="hidden" value="0" name="public[]" />
<input type="checkbox" value="2" checked="true" name="public[]" id="form_public_2" /><label for="form_public_2">Two</label>
}
      end

      it "no :checked" do
        builder.collection(:public, [[:One, 1],[:Two, 2]], type: :checkbox).must_eq %{
<input type="checkbox" value="1" name="public[]" id="form_public_1" /><label for="form_public_1">One</label>
<input type="hidden" value="0" name="public[]" />
<input type="checkbox" value="2" name="public[]" id="form_public_2" /><label for="form_public_2">Two</label>
}
      end
    end

    describe "type: :checkbox with block" do
      it do
        # TODO: allow merging :class!
        builder.collection(:public, [[:One, 1],[:Two, 2],[:Three, 3]], type: :checkbox, checked: [2,3]) do |model:, options:, index:, **|
          builder.checkbox(:public, options.merge(label: false, class: [(index.even? ? :even : :odd)])) +
            builder.label(model.first, for: options[:id], "data-action": :create)

        end.must_eq %{
<input type="checkbox" value="1" class="even" name="public[]" id="form_public_1" /><label for="form_public_1" data-action="create">One</label>
<input type="checkbox" value="2" checked="true" class="odd" name="public[]" id="form_public_2" /><label for="form_public_2" data-action="create">Two</label>
<input type="hidden" value="0" name="public[]" />
<input type="checkbox" value="3" checked="true" class="even" name="public[]" id="form_public_3" /><label for="form_public_3" data-action="create">Three</label>}
      end
    end

    describe "type: :select" do
      # nothing selected.
      it do
        builder.collection(:public, [[:One, 1],[:Two, 2],[:Three, 3]], type: :select).must_eq %{
<select name="public" id="form_public">
<option value="1">One</option>
<option value="2">Two</option>
<option value="3">Three</option>
</select>}
      end

      it do
        builder.collection(:public, [[:One, 1],[:Two, 2],[:Three, 3]], type: :select, selected: [2]).must_eq %{
<select name="public" id="form_public">
<option value="1">One</option>
<option value="2" selected="true">Two</option>
<option value="3">Three</option>
</select>}
      end

      #
    end
  end

  describe "#select" do
    it do
      builder.select :public, [[:One, 1],[:Two, 2],[:Three, 3]] do |select:, model:, **|
        select.option(model.first, value: model.last) # TODO: alias to label.
      end.must_eq %{
<select name="public" id="form_public">
<option value="1">One</option>
<option value="2">Two</option>
<option value="3">Three</option>
</select>}
    end

    # selected explicitly.
    it do
      builder.select :public, [[:One, 1],[:Two, 2],[:Three, 3]] do |select:, model:, **|
        select.option(model.first, value: model.last, selected: (model.last == 2)) # TODO: alias to label.
      end.must_eq %{
<select name="public" id="form_public">
<option value="1">One</option>
<option value="2" selected="true">Two</option>
<option value="3">Three</option>
</select>}
    end

    # selected as DSL.
    it do
      builder.select(:public, [[:One, 1],[:Two, 2],[:Three, 3]], selected: [2, 1]).must_eq %{
<select name="public" id="form_public">
<option value="1" selected="true">One</option>
<option value="2" selected="true">Two</option>
<option value="3">Three</option>
</select>}
    end
  end

  describe "#form" do
    it { builder.form().must_eq %{<form  />} }
    # no block is ok.
    it { builder.form() {}.must_eq %{<form  />} }
    it { builder.form(class: [:bright]) {}.must_eq %{<form class="bright" />} }
  end
end
