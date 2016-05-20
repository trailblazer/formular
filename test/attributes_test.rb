require "test_helper"
require "formular/attributes"

class AttributesTest < Minitest::Spec
  describe "::[]" do
    it { Formular::Attributes[nil].must_equal({}) }
    it { Formular::Attributes[class: []].must_equal({ class: [] }) }
  end

  describe "#merge!" do
    it do
      attrs = Formular::Attributes["data-remote": true]
      attrs.merge!(class: [:group]).must_equal("data-remote": true, class: [:group])
    end

    it do
      attrs = Formular::Attributes[class: [:control]]
      attrs.merge!(class: [:group])
      attrs.must_equal(class: [:group, :control])
    end
  end

  describe "#to_html" do
    it "should convert value as array correctly" do
      attrs = Formular::Attributes[value: "my value", type: "text", class: ["class1", "class2"]]
      attrs.to_html.must_equal %(value="my value" type="text" class="class1 class2")
    end

    it "should convert value as hash correctly" do
      attrs = Formular::Attributes[value: "my value", type: "text", data: { remote: true, some_other_data_attr: "foo" }]
      attrs.to_html.must_equal %(value="my value" type="text" data-remote="true" data-some-other-data-attr="foo")
    end

    it "should return a blank string when empty hash" do
      attrs = Formular::Attributes[{}]
      attrs.to_html.must_equal ""
    end
  end
end
