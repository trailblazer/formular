require 'test_helper'
require "formular/elements"

describe Formular::Elements::Checkbox do
  describe "unchecked" do
    let(:element) {Formular::Elements::Checkbox.(name: "public", value: 1)}

    it "#attributes" do
      element.attributes.must_equal(name: "public", type: "checkbox", value: 1)
    end

    it "#options" do
      element.options.must_equal({})
    end

    it "#to_s" do
      element.to_s.must_equal %(<input type="checkbox" name="public" value="1"/>)
    end
  end

  describe "checked" do
    let(:element) {Formular::Elements::Checkbox.(name: "public", value: 1, checked: 'checked')}

    it "#attributes" do
      element.attributes.must_equal(name: "public", type: "checkbox", value: 1, checked: "checked")
    end

    it "#options" do
      element.options.must_equal({})
    end

    it "#to_s" do
      element.to_s.must_equal %(<input type="checkbox" name="public" value="1" checked="checked"/>)
    end
  end
end