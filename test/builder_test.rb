require "test_helper"
require "formular/builder"

describe Formular::Builder do
  let(:model) { Comment.new(nil, nil, [Reply.new]) }
  let(:element_set) {  Formular::ElementSet.new({label: Formular::Elements::Label, submit: Formular::Elements::Submit}) }
  let(:builder) { Formular::Builder.new(element_set, model) }

  describe "#method_missing" do
    it "should call correct class" do
      builder.label({},content: "H").to_s.must_equal "<label>H</label>"
      builder.label.to_s.must_equal "<label>"

      builder.submit.class.must_equal Formular::Elements::Submit
    end
  end
end