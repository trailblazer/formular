require 'test_helper'
require "formular/elements/fieldset"

describe Formular::Elements::Fieldset do
  it "::tag" do
    element = Formular::Elements::Fieldset.new
    element.tag.must_equal("fieldset")
  end


  describe "contents as string" do
    it "#to_s" do
      element = Formular::Elements::Fieldset.new({}, content: "<legend>Hello</legend>")
      element.to_s.must_equal %(<fieldset><legend>Hello</legend></fieldset>)
    end
  end

  describe "contents as block" do
    it "#to_s" do
      element = Formular::Elements::Fieldset.new do |output|
        output << "<legend>Hello</legend>"
        output << Formular::Elements::Label.new({class: ["control-label"]}, content: "A handy label").to_s
      end
      element.to_s.must_equal %(<fieldset><legend>Hello</legend><label class="control-label">A handy label</label></fieldset>)
    end
  end

  describe "no contents" do
    let(:element) { Formular::Elements::Fieldset.new({class: ["grouping"]}) }

    it "#to_s" do
      element.to_s.must_equal %(<fieldset class="grouping">)
    end

    it "#end" do
      element.end.must_equal %(</fieldset>)
    end
  end
end