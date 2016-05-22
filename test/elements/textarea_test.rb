require 'test_helper'
require "formular/elements/textarea"

describe Formular::Elements::Textarea do
  it "::tag" do
    element = Formular::Elements::Textarea.()
    element.tag.must_equal("textarea")
  end

  describe "contents as string" do
    it "#to_s" do
      element = Formular::Elements::Textarea.({}, content: "Some lovely words here...")
      element.to_s.must_equal %(<textarea>Some lovely words here...</textarea>)
    end
  end

  describe "contents as block" do
    it "#to_s" do
      element = Formular::Elements::Textarea.() do
        concat "Part 1 text; "
        concat "Part 2 text"
      end
      element.to_s.must_equal %(<textarea>Part 1 text; Part 2 text</textarea>)
    end
  end

  describe "no contents" do
    let(:element) { Formular::Elements::Textarea.({rows: 3}) }

    it "#to_s" do
      element.to_s.must_equal %(<textarea rows="3">)
    end

    it "#end" do
      element.end.must_equal %(</textarea>)
    end
  end
end