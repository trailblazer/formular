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
end