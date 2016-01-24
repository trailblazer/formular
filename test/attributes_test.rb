require "test_helper"

class AttributesTest < Minitest::Spec
  let (:attrs) { Formular::Attributes["data-remote": true] }

  describe "::[]" do
    it { Formular::Attributes[nil].must_equal({}) }
    it { Formular::Attributes[class: []].must_equal({ class: [] }) }
  end

  it do
    attrs.merge!(class: [:group]).must_equal("data-remote": true, class: [:group])
  end

  it do
    attrs = Formular::Attributes[class: [:control]]
    attrs.merge!(class: [:group])
    attrs.must_equal(class: [:group, :control])
  end
end
