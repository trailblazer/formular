require 'test_helper'
require 'formular/element'

describe Formular::Element do
  El1 = Class.new(Formular::Element) { tag :p }
  El2 = Class.new(El1)
  El3 = Class.new(El1) { tag :div }

  describe 'set your tag' do
    it('::tag_name') { El1.tag_name.must_equal :p }
    it('#tag') { El1.().tag.must_equal :p }
  end

  describe 'inherit tag' do
    it('::tag_name') { El2.tag_name.must_equal :p }
    it('#tag') { El2.().tag.must_equal :p }
  end

  describe 'override inheritted tag' do
    it('::tag_name') { El3.tag_name.must_equal :div }
    it('#tag') { El3.().tag.must_equal :div }
  end

  describe '#normalize_options' do
    class CorrectAttrsInput < Formular::Element
      tag :input
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
      element.options[:option_1].must_be_nil
    end

    it 'should exclude nil keys' do
      element.options.must_equal(value: "some value", option_2: "an option", class: ["some-class"], opt: "Keep me")
    end

    it 'should allow defaults to be overriden' do
      element = CorrectAttrsInput.(value: 'some value', class: ['another-class'], option_1: 'I don\'t care if you\'re happy!')

      element.attributes.must_equal(value: 'some value', class: ['another-class', 'some-class'])
      element.options.must_equal(value: "some value", class: ["another-class", "some-class"], option_1: "I don't care if you're happy!", opt: "Keep me")
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