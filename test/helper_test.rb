require 'test_helper'
require 'formular/helper'

class HelperTest < Minitest::Spec
  include Formular::Helper

  model = OpenStruct.new

  it "should be Basic by default" do
    Formular::Helper._builder.must_equal :basic
  end

  it "should set default builder" do
    Formular::Helper.builder(:bootstrap3)
    Formular::Helper._builder.must_equal :bootstrap3
    Formular::Helper.builder(:basic) # return it back for other tests
  end

  it "should allow me to override the default builder" do
    Formular::Helper._builder.must_equal :basic
    form(model, "", builder: :foundation6).builder.class.must_equal Formular::Builders::Foundation6
  end
end
