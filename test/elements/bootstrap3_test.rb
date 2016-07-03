require 'test_helper'
require "formular/builders/bootstrap3"
require "formular/elements/bootstrap3"

#if we can test that each input renders the expected html here
#than all we need to do in the builders is test that the correct elements are included
describe Formular::Elements::Bootstrap3 do
  let(:builder) { Formular::Builders::Bootstrap3.new() }
  describe 'bs3 input groups' do
    describe 'with addons as options' do
      let(:element) { builder.input_group(:url, label: 'URL', left_addon: 'http://', right_addon: '.com', value: 'www.trailblazer.to') }

      it "returns correct html" do
        element.to_s.must_equal %(<div class="form-group"><label for="url" class="control-label">URL</label><div class="input-group"><span class="input-group-addon">http://</span><input name="url" id="url" type="text" class="form-control" value="www.trailblazer.to"/><span class="input-group-addon">.com</span></div></div>)
      end
    end

    describe 'with buttons as options' do
      let(:element) { builder.input_group(:url, label: 'URL', left_btn: '<a class="btn btn-default" href="/some_path">Click Me</a>', right_btn: '<a class="btn btn-default" href="/some_path">Click Me</a>', value: 'www.trailblazer.to') }

      it "returns correct html" do
        element.to_s.must_equal %(<div class="form-group"><label for="url" class="control-label">URL</label><div class="input-group"><span class="input-group-btn"><a class="btn btn-default" href="/some_path">Click Me</a></span><input name="url" id="url" type="text" class="form-control" value="www.trailblazer.to"/><span class="input-group-btn"><a class="btn btn-default" href="/some_path">Click Me</a></span></div></div>)
      end
    end

    describe 'with block' do
      let(:element) {
        builder.input_group(:title, label: "Title", value: "John Smith") do |input, output|
          output.concat input.group_addon('<input name="default[]" id="default" type="checkbox" value="1">')
          output.concat input.control
          output.concat input.group_btn('<button type="submit" class="btn btn-default">Go!</button>')
        end
      }

      it "returns correct html" do
        element.to_s.must_equal %(<div class="form-group"><label for="title" class="control-label">Title</label><div class="input-group"><span class="input-group-addon"><input name="default[]" id="default" type="checkbox" value="1"></span><input name="title" id="title" type="text" class="form-control" value="John Smith"/><span class="input-group-btn"><button type="submit" class="btn btn-default">Go!</button></span></div></div>)
      end
    end
  end

  describe Formular::Elements::Bootstrap3::Input do
    let(:element) { builder.input }

    it "::attributes" do
      element.attributes.must_equal({type: "text", class: ["form-control"]})
    end

    describe "returns correct html" do
      it "with value" do
        element = builder.input(:name, value: "Joseph Smith")
        element.to_s.must_equal %(<div class="form-group"><input name="name" id="name" type="text" class="form-control" value="Joseph Smith"/></div>)
      end

      it "with label" do
        element = builder.input(:name, label: "Name")
        element.to_s.must_equal %(<div class="form-group"><label for="name" class="control-label">Name</label><input name="name" id="name" type="text" class="form-control"/></div>)
      end

      it "with hint" do
        element = builder.input(:name, hint: "Some helpful words")
        element.to_s.must_equal %(<div class="form-group"><input name="name" id="name" type="text" aria-describedby="name_hint" class="form-control"/><span class="help-block" id="name_hint">Some helpful words</span></div>)
      end

      it "with error" do
        element = builder.input(:name, error: "Something nasty happened")
        element.to_s.must_equal %(<div class="form-group has-error"><input name="name" id="name" type="text" class="form-control"/><span class="help-block">Something nasty happened</span></div>)
      end

      it "all together!" do
        element = builder.input(:name, value: "Joseph Smith", label: "Name", error: "Something nasty happened", hint: "Some helpful words")
        element.to_s.must_equal %(<div class="form-group has-error"><label for="name" class="control-label">Name</label><input name="name" id="name" type="text" aria-describedby="name_hint" class="form-control" value="Joseph Smith"/><span class="help-block" id="name_hint">Some helpful words</span><span class="help-block">Something nasty happened</span></div>)
      end
    end
  end

  describe Formular::Elements::Bootstrap3::Checkbox do
    let(:element) { builder.checkbox(:public, value: 1, label: "Public") }

    it "::attributes" do
      element.attributes.must_equal(name: "public[]", id: "public", type: "checkbox", value: 1)
    end

    describe "returns correct html" do
      it "with value and label" do
        element.to_s.must_equal %(<div class="form-group"><div class="checkbox"><label><input name="public[]" id="public" type="checkbox" value="1"/> Public</label></div></div>)
      end

      it "with hint" do
        element = builder.checkbox(:public, value: 1, label: "Public", hint: "Some helpful words")
        element.to_s.must_equal %(<div class="form-group"><div class="checkbox"><label><input name="public[]" id="public" type="checkbox" aria-describedby="public_hint" value="1"/> Public</label></div><span class="help-block" id="public_hint">Some helpful words</span></div>)
      end

      it "with error" do
        element = builder.checkbox(:public, value: 1, label: "Public", error: "Something nasty happened")
        element.to_s.must_equal %(<div class="form-group has-error"><div class="checkbox"><label><input name="public[]" id="public" type="checkbox" value="1"/> Public</label></div><span class="help-block">Something nasty happened</span></div>)
      end

      it "all together!" do
        element = builder.checkbox(:public, value: 1, label: "Public", error: "Something nasty happened", hint: "Some helpful words")
        element.to_s.must_equal %(<div class="form-group has-error"><div class="checkbox"><label><input name="public[]" id="public" type="checkbox" aria-describedby="public_hint" value="1"/> Public</label></div><span class="help-block" id="public_hint">Some helpful words</span><span class="help-block">Something nasty happened</span></div>)
      end

      describe "with collection" do
        let(:collection) { [[1, "Option 1"], [2, "Option 2"]] }
        it "only collection" do
          element = builder.checkbox(:public, collection: collection)
          element.to_s.must_equal %(<div class="form-group"><div class="checkbox"><label><input name="public[]" id="public_1" type="checkbox" value="1"/> Option 1</label></div><div class="checkbox"><label><input name="public[]" id="public_2" type="checkbox" value="2"/> Option 2</label></div></div>)
        end

        it "with group label" do
          element = builder.checkbox(:public, label: "Public", collection: collection)
          element.to_s.must_equal %(<div class="form-group"><label class="control-label">Public</label><div class="checkbox"><label><input name="public[]" id="public_1" type="checkbox" value="1"/> Option 1</label></div><div class="checkbox"><label><input name="public[]" id="public_2" type="checkbox" value="2"/> Option 2</label></div></div>)
        end

        it "with hint" do
          element = builder.checkbox(:public, collection: collection, hint: "Some helpful words")
          element.to_s.must_equal %(<div class="form-group"><div class="checkbox"><label><input name="public[]" id="public_1" type="checkbox" aria-describedby="public_hint" value="1"/> Option 1</label></div><div class="checkbox"><label><input name="public[]" id="public_2" type="checkbox" aria-describedby="public_hint" value="2"/> Option 2</label></div><span class="help-block" id="public_hint">Some helpful words</span></div>)
        end

        it "with error" do
          element = builder.checkbox(:public, collection: collection, error: "Something nasty happened")
          element.to_s.must_equal %(<div class="form-group has-error"><div class="checkbox"><label><input name="public[]" id="public_1" type="checkbox" value="1"/> Option 1</label></div><div class="checkbox"><label><input name="public[]" id="public_2" type="checkbox" value="2"/> Option 2</label></div><span class="help-block">Something nasty happened</span></div>)
        end

        it "all together!" do
          element = builder.checkbox(:public, label: "Public", collection: collection, hint: "Some helpful words", error: "Something nasty happened")
          element.to_s.must_equal %(<div class="form-group has-error"><label class="control-label">Public</label><div class="checkbox"><label><input name="public[]" id="public_1" type="checkbox" aria-describedby="public_hint" value="1"/> Option 1</label></div><div class="checkbox"><label><input name="public[]" id="public_2" type="checkbox" aria-describedby="public_hint" value="2"/> Option 2</label></div><span class="help-block" id="public_hint">Some helpful words</span><span class="help-block">Something nasty happened</span></div>)
        end
      end
    end
  end

  describe Formular::Elements::Bootstrap3::Radio do
    let(:element) { builder.radio(:public, value: true, label: "Public") }

    it "::attributes" do
      element.attributes.must_equal(name: "public", id: "public", type: "radio", value: true)
    end

    it "#to_s" do
      element.to_s.must_equal %(<div class="form-group"><div class="radio"><label><input name="public" id="public" type="radio" value="true"/> Public</label></div></div>)
    end

    describe "with collection" do
      let(:element) { builder.radio(:public, collection: [[1, "Option 1"], [2, "Option 2"]]) }

      it "#to_s" do
        element.to_s.must_equal %(<div class="form-group"><div class="radio"><label><input name="public" id="public_1" type="radio" value="1"/> Option 1</label></div><div class="radio"><label><input name="public" id="public_2" type="radio" value="2"/> Option 2</label></div></div>)
      end
    end
  end

  describe Formular::Elements::Bootstrap3::InlineCheckbox do
    let(:element) { builder.inline_checkbox(:public, value: 1, label: "Public") }

    it "::attributes" do
      element.attributes.must_equal(name: "public[]", id: "public", type: "checkbox", value: 1)
    end

    it "#to_s" do
      element.to_s.must_equal %(<div class="form-group"><label class="checkbox-inline"><input name="public[]" id="public" type="checkbox" value="1"/> Public</label></div>)
    end

    describe "with collection" do
      let(:collection) { [[1, "Option 1"], [2, "Option 2"]] }

      it "only collection" do
        element = builder.inline_checkbox(:public, collection: collection)
        element.to_s.must_equal %(<div class="form-group"><label class="checkbox-inline"><input name="public[]" id="public_1" type="checkbox" value="1"/> Option 1</label><label class="checkbox-inline"><input name="public[]" id="public_2" type="checkbox" value="2"/> Option 2</label></div>)
      end

      it "with group label" do
        element = builder.inline_checkbox(:public, label: "Public", collection: collection)
        element.to_s.must_equal %(<div class="form-group"><label class="control-label">Public</label><div><label class="checkbox-inline"><input name="public[]" id="public_1" type="checkbox" value="1"/> Option 1</label><label class="checkbox-inline"><input name="public[]" id="public_2" type="checkbox" value="2"/> Option 2</label></div></div>)
      end

      it "with hint" do
        element = builder.inline_checkbox(:public, collection: collection, hint: "Some helpful words")
        element.to_s.must_equal %(<div class="form-group"><label class="checkbox-inline"><input name="public[]" id="public_1" type="checkbox" aria-describedby="public_hint" value="1"/> Option 1</label><label class="checkbox-inline"><input name="public[]" id="public_2" type="checkbox" aria-describedby="public_hint" value="2"/> Option 2</label><span class="help-block" id="public_hint">Some helpful words</span></div>)
      end

      it "with error" do
        element = builder.inline_checkbox(:public, collection: collection, error: "Something nasty happened")
        element.to_s.must_equal %(<div class="form-group has-error"><label class="checkbox-inline"><input name="public[]" id="public_1" type="checkbox" value="1"/> Option 1</label><label class="checkbox-inline"><input name="public[]" id="public_2" type="checkbox" value="2"/> Option 2</label><span class="help-block">Something nasty happened</span></div>)
      end

      it "all together!" do
        element = builder.inline_checkbox(:public, label: "Public", collection: collection, hint: "Some helpful words", error: "Something nasty happened")
        element.to_s.must_equal %(<div class="form-group has-error"><label class="control-label">Public</label><div><label class="checkbox-inline"><input name="public[]" id="public_1" type="checkbox" aria-describedby="public_hint" value="1"/> Option 1</label><label class="checkbox-inline"><input name="public[]" id="public_2" type="checkbox" aria-describedby="public_hint" value="2"/> Option 2</label></div><span class="help-block" id="public_hint">Some helpful words</span><span class="help-block">Something nasty happened</span></div>)
      end
    end
  end

  describe Formular::Elements::Bootstrap3::InlineRadio do
    let(:element) { builder.inline_radio(:public, value: true, label: "Public") }

    it "::attributes" do
      element.attributes.must_equal(name: "public", id: "public", type: "radio", value: true)
    end

    it "#to_s" do
      element.to_s.must_equal %(<div class="form-group"><label class="radio-inline"><input name="public" id="public" type="radio" value="true"/> Public</label></div>)
    end

    describe "with collection" do
      let(:element) { builder.inline_radio(:public, collection: [[1, "Option 1"], [2, "Option 2"]]) }

      it "#to_s" do
        element.to_s.must_equal %(<div class="form-group"><label class="radio-inline"><input name="public" id="public_1" type="radio" value="1"/> Option 1</label><label class="radio-inline"><input name="public" id="public_2" type="radio" value="2"/> Option 2</label></div>)
      end
    end
  end

  describe "independent errors" do
    let(:builder) { Formular::Builders::Bootstrap3.new(errors: { body: ["This really isn't good enough!"] }) }

    it "#error should return the error element for :body" do
      element = builder.error(:body)
      element.to_s.must_equal %(<span class="help-block">This really isn't good enough!</span>)
    end
  end

  describe "independent hints" do
    it "#error should return the error element for :body" do
      element = builder.hint(content: "Something helpful")
      element.to_s.must_equal %(<span class="help-block">Something helpful</span>)
    end
  end

  describe "independent labels" do
    it "#error should return the error element for :body" do
      element = builder.label(:body, content: "Some words...")
      element.to_s.must_equal %(<label for="body" class="control-label">Some words...</label>)
    end
  end
end