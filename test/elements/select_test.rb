require 'test_helper'
require "formular/elements"

describe Formular::Elements::Select do
  let(:element) {Formular::Elements::Select.(name: "public", collection: [[0, "False"], [1, "True"]], value: 0)}
  it "#tag" do
    element.tag.must_equal "select"
  end
  it "#attributes" do
    element.attributes.must_equal({name: "public"})
  end

  it "#options" do
    element.options.must_equal(collection: [[0, "False"], [1, "True"]], value: 0)
  end

  it "#to_s" do
    element.to_s.must_equal %(<select name="public"><option value="0" selected="selected">False</option><option value="1">True</option></select>)
  end

  describe "#option_tags" do
    describe "simple array" do
      let(:element) {Formular::Elements::Select.(name: "public", collection: [[0, "False"], [1, "True"]], value: 0)}

      it "return correct tags" do
        element.option_tags.must_equal %(<option value="0" selected="selected">False</option><option value="1">True</option>)
      end
    end
    describe "nested array" do
      let(:element) {Formular::Elements::Select.(name: "public", collection: [["Genders", [["m", "Male"], ["f", "Female"]]], ["Booleans", [[1,"True"], [0,"False"]]]], value: "m")}

      it "return correct tags" do
        element.option_tags.must_equal %(<optgroup label="Genders"><option value="m" selected="selected">Male</option><option value="f">Female</option></optgroup><optgroup label="Booleans"><option value="1">True</option><option value="0">False</option></optgroup>)
      end
    end
  end


end