require 'test_helper'
require 'formular/element/modules/wrapped'
require 'formular/elements'
require 'formular/builders/basic'

describe 'labels module' do
  class WrappedInput < Formular::Element::Input
    tag :input
    include Formular::Element::Modules::Wrapped
  end

  let(:builder) do
    Formular::Builders::Basic.new(elements: { wrapped_input: WrappedInput })
  end

  describe '#options[:label]' do
    it 'should be correct string' do
      element = builder.wrapped_input(:some_attribute, label: 'Some string')
      element.options[:label].must_equal 'Some string'
    end
  end

  describe 'builder has attribute error' do
    describe '#has_label?' do
      it 'option is nil then should be false' do
        element = builder.wrapped_input(:body)
        element.has_label?.must_equal false
      end

      it 'option is false then should be false' do
        element = builder.wrapped_input(:body, label: false)
        element.has_label?.must_equal false
      end
    end

    describe '#label_text' do
      it 'option is false then should be nil' do
        element = builder.wrapped_input(:body, hint: false)
        element.label_text.must_be_nil
      end

      it 'return custom message' do
        element = builder.wrapped_input(:body, label: 'Some string')
        element.label_text.must_equal 'Some string'
      end

      it 'should be html escaped' do
        element = builder.wrapped_input(:body, label: "I'm a little teapot whose spout is > 10cm")
        element.label_text.must_equal "I&#39;m a little teapot whose spout is &gt; 10cm"
      end
    end
  end

  describe 'returns correct html' do
    it '#hint' do
      element = builder.label(content: 'Some label')
      element.to_s.must_equal %(<label>Some label</label>)
    end

    it '#wrapped input should include the label' do
      element = builder.wrapped_input(:body, label: 'Body')
      element.to_s.must_equal %(<div><label for="body">Body</label><input name="body" id="body" type="text"/></div>)
    end
  end
end
