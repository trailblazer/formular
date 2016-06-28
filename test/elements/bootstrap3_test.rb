require 'test_helper'
require "formular/builders/bootstrap3"
require "formular/elements/bootstrap3"

#if we can test that each input renders the expected html here
#than all we need to do in the builders is test that the correct elements are included
describe Formular::Elements::Bootstrap3 do
  let(:builder) { Formular::Builders::Bootstrap3.new }
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
        builder.input_group(:title, label: "Title", value: "John Smith") do |group|
          concat group.input_addon('<input name="default[]" id="default" type="checkbox" value="1">')
          concat group.input
          concat group.input_btn('<button type="submit" class="btn btn-default">Go!</button>')
        end
      }

      it "returns correct html" do
        element.to_s.must_equal %(<div class="form-group"><label for="title" class="control-label">Title</label><div class="input-group"><span class="input-group-addon"><input name="default[]" id="default" type="checkbox" value="1"></span><input name="title" id="title" type="text" class="form-control" value="John Smith"/><span class="input-group-btn"><button type="submit" class="btn btn-default">Go!</button></span></div></div>)
      end
    end
  end

  describe Formular::Elements::Bootstrap3::Input do
    let(:element) { builder.input }

    it "::tag" do
      element.tag.must_equal("input")
    end

    it "::attributes" do
      element.attributes.must_equal({type: "text", class: ["form-control"]})
    end

    describe "returns correct html" do
      it "#to_s" do
        element = builder.input(label: "Name", value: "Joseph Smith")
        element.to_s.must_equal %(<div class="form-group"><label class="control-label">Name</label><input type="text" class="form-control" value="Joseph Smith"/></div>)
      end
    end
  end

  describe Formular::Elements::Bootstrap3::Checkbox do
    let(:element) { builder.checkbox(:public, value: 1, label: "Public") }

    it "::tag" do
      element.tag.must_equal("input")
    end

    it "::attributes" do
      element.attributes.must_equal(name: "public[]", id: "public", type: "checkbox", value: 1)
    end

    it "#to_s" do
      element.to_s.must_equal %(<div class="form-group"><div class="checkbox"><label><input name="public[]" id="public" type="checkbox" value="1"/> Public</label></div></div>)
    end

    describe "with collection" do
      let(:element) { builder.checkbox(:public, label: "Public", collection: [[1, "Option 1"], [2, "Option 2"]]) }

      it "#to_s" do
        element.to_s.must_equal %(<div class="form-group"><label class="control-label">Public</label><div class="checkbox"><label><input name="public[]" id="public_1" type="checkbox" value="1"/> Option 1</label></div><div class="checkbox"><label><input name="public[]" id="public_2" type="checkbox" value="2"/> Option 2</label></div></div>)
      end
    end
  end

  describe Formular::Elements::Bootstrap3::Radio do
    let(:element) { builder.radio(:public, value: true, label: "Public") }

    it "::tag" do
      element.tag.must_equal("input")
    end

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

    it "::tag" do
      element.tag.must_equal("input")
    end

    it "::attributes" do
      element.attributes.must_equal(name: "public[]", id: "public", type: "checkbox", value: 1)
    end

    it "#to_s" do
      element.to_s.must_equal %(<div class="form-group"><label class="checkbox-inline"><input name="public[]" id="public" type="checkbox" value="1"/> Public</label></div>)
    end

    describe "with collection" do
      let(:element) { builder.inline_checkbox(:public, collection: [[1, "Option 1"], [2, "Option 2"]]) }

      it "#to_s" do
        element.to_s.must_equal %(<div class="form-group"><label class="checkbox-inline"><input name="public[]" id="public_1" type="checkbox" value="1"/> Option 1</label><label class="checkbox-inline"><input name="public[]" id="public_2" type="checkbox" value="2"/> Option 2</label></div>)
      end
    end
  end

  describe Formular::Elements::Bootstrap3::InlineRadio do
    let(:element) { builder.inline_radio(:public, value: true, label: "Public") }

    it "::tag" do
      element.tag.must_equal("input")
    end

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
end