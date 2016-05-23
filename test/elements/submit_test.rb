require 'test_helper'
require "formular/elements"

describe Formular::Elements::Submit do
  let(:element) {Formular::Elements::Submit.(value: "Submit Button")}
  it "#tag" do
    element.tag.must_equal "input"
  end
  it "#attributes" do
    element.attributes.must_equal({type: "submit", value: "Submit Button"})
  end
  it "#to_s" do
    element.to_s.must_equal %(<input type="submit" value="Submit Button"/>)
  end
end