require 'test_helper'
require 'formular/element/modules/wrapped'
require 'formular/elements'
require 'formular/builders/basic'

describe 'hints module' do
  class WrappedInput < Formular::Element::Input
    tag :input
    include Formular::Element::Modules::Wrapped
  end

  let(:builder) do
    Formular::Builders::Basic.new(elements: { wrapped_input: WrappedInput })
  end

  describe '#options[:hint]' do
    it 'should be correct string' do
      element = builder.wrapped_input(:some_attribute, hint: 'Some string')
      element.options[:hint].must_equal 'Some string'
    end
  end

  describe 'builder has attribute error' do
    describe '#has_hint?' do
      it 'option is nil then should be false' do
        element = builder.wrapped_input(:body)
        element.has_hint?.must_equal false
      end

      it 'option is false then should be false' do
        element = builder.wrapped_input(:body, hint: false)
        element.has_hint?.must_equal false
      end
    end

    describe '#hint_text' do
      it 'option is false then should be nil' do
        element = builder.wrapped_input(:body, hint: false)
        element.hint_text.must_be_nil
      end

      it 'return custom message' do
        element = builder.wrapped_input(:body, hint: 'Some string')
        element.hint_text.must_equal 'Some string'
      end

      it 'should be html escaped' do
        element = builder.wrapped_input(:body, hint: "I'm a little teapot whose spout is > 10cm")
        element.hint_text.must_equal "I&#39;m a little teapot whose spout is &gt; 10cm"
      end
    end
  end

  describe 'returns correct html' do
    it '#hint' do
      element = builder.hint(content: 'Some message')
      element.to_s.must_equal %(<p>Some message</p>)
    end

    it '#wrapped input should include the hint' do
      element = builder.wrapped_input(:body, hint: 'Some hint')
      element.to_s.must_equal %(<div><input name="body" id="body" type="text" aria-describedby="body_hint"/><p id="body_hint">Some hint</p></div>)
    end
  end
end
