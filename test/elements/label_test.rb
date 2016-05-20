require 'test_helper'
require "formular/elements/label"

describe Formular::Elements::Label do
  it "::tag" do
    element = Formular::Elements::Label.new
    element.tag.must_equal("label")
  end


  describe "contents as string" do
    it "#to_s" do
      element = Formular::Elements::Label.new({}, content: "What a nice label")
      element.to_s.must_equal %(<label>What a nice label</label>)
    end
  end

  describe "contents as block" do
    it "#to_s" do
      element = Formular::Elements::Label.new do |output|
        output << "something "
        output << "super "
        output << "dooper"
      end
      element.to_s.must_equal %(<label>something super dooper</label>)
    end
  end

  describe "no contents" do
    let(:element) { Formular::Elements::Label.new({class: ["control-label"]}) }

    it "#to_s" do
      element.to_s.must_equal %(<label class="control-label">)
    end

    it "#end" do
      element.end.must_equal %(</label>)
    end
  end
end