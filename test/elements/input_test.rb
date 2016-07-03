require 'test_helper'
require "formular/elements"

describe Formular::Elements::Input do
  let(:element) {Formular::Elements::Input.(type: "text", value: "Some text")}

  it "#attributes" do
    element.attributes.must_equal(type: "text", value: "Some text")
  end

  it "#to_s" do
    element.to_s.must_equal %(<input type="text" value="Some text"/>)
  end
end