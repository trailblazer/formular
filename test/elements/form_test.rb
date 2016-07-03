require 'test_helper'
require "formular/elements"

describe Formular::Elements::Form do
  describe "contents as string" do
    it "#to_s" do
      element = Formular::Elements::Form.(content: "<h1>Edit Form</h1>")
      element.to_s.must_equal %(<form method="post"><h1>Edit Form</h1></form>)
    end
  end

  describe "contents as block" do
    it "#to_s" do
      element = Formular::Elements::Form.() do |f, output|
        output.concat "<h1>Edit Form</h1>"
        output.concat Formular::Elements::Label.(class: ["control-label"], content: "A handy label")
      end
      element.to_s.must_equal %(<form method="post"><h1>Edit Form</h1><label class="control-label">A handy label</label></form>)
    end
  end

  describe "no contents" do
    let(:element) { Formular::Elements::Form.(method: "put", class: ["grouping"]) }

    it "#to_s" do
      element.to_s.must_equal %(<form method="put" class="grouping">)
    end

    it "#end" do
      element.end.must_equal %(</form>)
    end
  end
end