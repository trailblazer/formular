require 'test_helper'
require "formular/elements"

describe Formular::Elements::Button do
  it "returns correct html" do
    element = Formular::Elements::Button.(href:'/some_path', value: "Button")
    element.to_s.must_equal %(<button href="/some_path">Button</button>)
  end
end