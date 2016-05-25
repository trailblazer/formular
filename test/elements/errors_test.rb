require 'test_helper'
require "formular/elements"
require "formular/builders/basic"

#control elements in the Basic builder include the errors module so we can test that
#that the controls respond correctly to the error module methods
describe "errors module" do
  let(:builder) { Formular::Builders::Basic.new(errors: {body: ["This really isn't good enough!"], public: ["What's wrong with you??!"]}) }

  describe "#options[:error]" do
    it "should be false" do
      element = builder.input(:some_attribute, error: false)
      element.options[:error].must_equal false
    end

    it "should be correct string" do
      element = builder.input(:some_attribute, error: "Some string")
      element.options[:error].must_equal "Some string"
    end
  end

  describe "builder has attribute error" do
    describe "#has_errors?" do
      it "should be true" do
        element = builder.input(:body)
        element.has_errors?.must_equal true
      end
      it "option is false then should be false" do
        element = builder.input(:body, error: false)
        element.has_errors?.must_equal false
      end
    end

    describe "#error_message" do
      it "should be builder message" do
        element = builder.input(:body)
        element.error_message.must_equal "This really isn't good enough!"
      end
      it "option is false then should be nil" do
        element = builder.input(:body, error: false)
        element.error_message.must_equal nil
      end
      it "return custom message" do
        element = builder.input(:body, error: "Some string")
        element.error_message.must_equal "Some string"
      end
    end
  end

  describe "builder hasn't got attribute error" do
    it "should be false" do
      element = builder.input(:some_other_attribute)
      element.has_errors?.must_equal false
    end

    it "when custom error should be true" do
      element = builder.input(:some_other_attribute, error: "I'm an error")
      element.has_errors?.must_equal true
    end
  end

  describe "returns correct html" do
    it "#error should return the error element for :body" do
      element = builder.error(:body)
      element.to_s.must_equal %(<p>This really isn't good enough!</p>)
    end

    #I'll test this when I test the wrapped control module
    # it "#wrapped input should include the error message" do
    #   element = builder.wrapped_input(:body, type: "text", label: false)
    #   element.to_s.must_equal %(<div class="error"><input name="body" id="body" type="text"/><p>This really isn't good enough!</p></div>)
    # end
  end
end