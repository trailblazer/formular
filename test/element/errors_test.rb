require 'test_helper'
require 'formular/elements'
require 'formular/builders/basic'

describe 'errors module' do
  let(:builder) { Formular::Builders::Basic.new }

  class WrappedInput < Formular::Element::Input
    tag :input
    include Formular::Element::Modules::Wrapped
  end

  class ErrorWrapper < Formular::Element::Div
    tag :div
    set_default :class, ['error']
  end

  let(:builder) do
    Formular::Builders::Basic.new(
      errors: {
        body: ['This really isn\'t good enough!'],
        public: ['What\'s wrong with you??!']
      },
      elements: {
        wrapped_input: WrappedInput,
        error_wrapper: ErrorWrapper
      }
    )
  end

  describe '#options[:error]' do
    it 'should be false' do
      element = builder.wrapped_input(:some_attribute, error: false)
      element.options[:error].must_equal false
    end

    it 'should be correct string' do
      element = builder.wrapped_input(:some_attribute, error: 'Some string')
      element.options[:error].must_equal 'Some string'
    end
  end

  describe 'builder has attribute error' do
    describe '#has_errors?' do
      it 'should be true' do
        element = builder.wrapped_input(:body)
        element.has_errors?.must_equal true
      end

      it 'option is false then should be false' do
        element = builder.wrapped_input(:body, error: false)
        element.has_errors?.must_equal false
      end
    end

    describe '#error_text' do
      it 'should be builder message' do
        element = builder.wrapped_input(:body)
        element.error_text.must_equal 'This really isn&#39;t good enough!'
      end

      it 'option is false then should be nil' do
        element = builder.wrapped_input(:body, error: false)
        element.error_text.must_be_nil
      end

      it 'return custom message' do
        element = builder.wrapped_input(:body, error: 'Some string')
        element.error_text.must_equal 'Some string'
      end

      it 'should be html escaped' do
        element = builder.wrapped_input(:body, error: "I'm a little teapot whose spout is > 10cm")
        element.error_text.must_equal "I&#39;m a little teapot whose spout is &gt; 10cm"
      end
    end
  end

  describe 'builder has no attribute error' do
    it 'should be false' do
      element = builder.wrapped_input(:some_other_attribute)
      element.has_errors?.must_equal false
    end

    it 'when custom error should be true' do
      element = builder.wrapped_input(:some_other_attribute, error: 'message')
      element.has_errors?.must_equal true
    end
  end

  describe 'returns correct html' do
    it '#error should return the error element for :body' do
      element = builder.error(:body)
      element.to_s.must_equal %(<p>This really isn&#39;t good enough!</p>)
    end

    it '#wrapped input should include the error message' do
      element = builder.wrapped_input(:body)
      element.to_s.must_equal %(<div class="error"><input name="body" id="body" type="text"/><p>This really isn&#39;t good enough!</p></div>)
    end
  end
end
