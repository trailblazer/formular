require 'test_helper'
require "formular/element_set"

describe Formular::ElementSet do
  let(:element_set) { Formular::ElementSet.new({label: Formular::Elements::Label, submit: Formular::Elements::Submit}) }

  describe "#[]" do
    it "should return correct element class" do
      element_set[:label].must_equal Formular::Elements::Label
      element_set[:submit].must_equal Formular::Elements::Submit
    end
  end
end