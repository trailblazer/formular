require 'test_helper'
require 'formular/element'

describe Formular::Element do
  describe 'gets tag from class name' do
    Input = Class.new(Formular::Element)
    it('::tag_name') { Input.tag_name.must_equal 'input' }
    it('#tag') { Input.().tag.must_equal 'input' }
  end

  describe 'can set your own tag' do
    ManualInput = Class.new(Formular::Element) { tag 'p' }
    it('::tag_name') { ManualInput.tag_name.must_equal 'p' }
    it('#tag') { ManualInput.().tag.must_equal 'p' }
  end

  describe '#normalize_attributes' do
    class CorrectAttrsInput < Formular::Element
      tag 'input'
      add_option_keys :option_1, :option_2, :option_3, :opt
      set_default :class, ['some-class']
      set_default :opt, 'Override me'
      set_default :option_1, 'Some super cool value', if: :happy?
      set_default :opt, 'Keep me'

      def happy?
        false
      end
    end
    let(:element) { CorrectAttrsInput.(value: 'some value', option_2: 'an option') }

    it 'attributes should exclude option_keys' do
      element.attributes.must_equal(value: 'some value', class: ['some-class'])
    end

    it 'should evaluate condition correctly' do
      element.options[:option_1].must_equal nil
    end

    it 'should exclude nil keys' do
      element.options.must_equal(opt: 'Keep me', option_2: 'an option')
    end

    it 'should allow defaults to be overriden' do
      element = CorrectAttrsInput.(value: 'some value', class: ['another-class'], option_1: 'I don\'t care if you\'re happy!')

      element.attributes.must_equal(value: 'some value', class: ['another-class', 'some-class'])
      element.options.must_equal(opt: 'Keep me', option_1: 'I don\'t care if you\'re happy!')
    end

    it 'should previously defined defaults to be overriden' do
      element = CorrectAttrsInput.()

      element.options[:opt].must_equal('Keep me')
    end
  end

  #::renderer - INHERIT

  #renderer
  #builder
end