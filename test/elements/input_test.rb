require 'test_helper'
require "formular/elements/input"

describe Formular::Elements::Input do
  let(:element) {Formular::Elements::Input.new(type: "text", value: "Some text")}
  it "#tag" do
    element.tag.must_equal "input"
  end
  it "#attributes" do
    element.attributes.must_equal({type: "text", value: "Some text"})
  end
  it "#to_s" do
    element.to_s.must_equal %(<input type="text" value="Some text"/>)
  end
end