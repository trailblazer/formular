require 'test_helper'
require "formular/builders/bootstrap3"
require "formular/elements/bootstrap3"

#if we can test that each input renders the expected html here
#than all we need to do in the builders is test that the correct elements are included
describe Formular::Elements::Bootstrap3 do
  let(:builder) { Formular::Builders::Bootstrap3.new }
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
      element.attributes.must_equal(name: "public", id: "public", type: "checkbox", value: 1)
    end

    describe "returns correct html" do
      it "#to_s" do
        element.to_s.must_equal %(<div class="form-group"><div class="checkbox"><label><input name="public" id="public" type="checkbox" value="1"/> Public</label></div></div>)
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

    describe "returns correct html" do
      it "#to_s" do
        element.to_s.must_equal %(<div class="form-group"><div class="radio"><label><input name="public" id="public" type="radio" value="true"/> Public</label></div></div>)
      end
    end
  end

  describe Formular::Elements::Bootstrap3::InlineCheckbox do
    let(:element) { builder.inline_checkbox(:public, value: 1, label: "Public") }

    it "::tag" do
      element.tag.must_equal("input")
    end

    it "::attributes" do
      element.attributes.must_equal(name: "public", id: "public", type: "checkbox", value: 1)
    end

    describe "returns correct html" do
      it "#to_s" do
        element.to_s.must_equal %(<div class="form-group"><label class="checkbox-inline"><input name="public" id="public" type="checkbox" value="1"/> Public</label></div>)
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

    describe "returns correct html" do
      it "#to_s" do
        element.to_s.must_equal %(<div class="form-group"><label class="radio-inline"><input name="public" id="public" type="radio" value="true"/> Public</label></div>)
      end
    end
  end
end