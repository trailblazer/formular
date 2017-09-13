require 'test_helper'
require 'formular/helper'
require 'formular/builder'

class HelperTest < Minitest::Spec
  SomeFancyBuilder = Class.new(Formular::Builders::Basic)
  FormHelperClass = Class.new { include Formular::Helper }

  form_class_instance = FormHelperClass.new
  model = OpenStruct.new

  it "should be Basic by default" do
    Formular::Helper._builder.must_equal :basic
    form_class_instance.form(model, "").builder.class.must_equal Formular::Builders::Basic
  end

  it "should set default builder" do
    Formular::Helper.builder(:bootstrap3)
    Formular::Helper._builder.must_equal :bootstrap3
    form_class_instance.form(model, "").builder.class.must_equal Formular::Builders::Bootstrap3
    Formular::Helper.builder(:basic) # return it back for other tests
  end

  it "should allow me to override the default builder" do
    Formular::Helper._builder.must_equal :basic
    form_class_instance.form(model, "").builder.class.must_equal Formular::Builders::Basic
    form_class_instance.form(model, "", builder: :foundation6).builder.class.must_equal Formular::Builders::Foundation6
  end


  it "should allow me to use my own builder" do
    Formular::Helper._builder.must_equal :basic
    form_class_instance.form(model, "", builder: SomeFancyBuilder).builder.class.must_equal SomeFancyBuilder
  end
end
