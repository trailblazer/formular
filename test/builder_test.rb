require 'test_helper'
require 'formular/builder'
require 'formular/elements'

describe Formular::Builder do
  BuilderElement =
    {
      label: Formular::Element::Label,
      input: Formular::Element::Input,
      form: Formular::Element::Form
   }.freeze

  let(:builder) {
    Formular::Builder.new(BuilderElement)
  }

  describe '#define_element_methods' do
    it 'should pass self to element' do
      builder.label(content: 'H').builder.must_equal builder
    end

    it 'should call correct element' do
      builder.label(content: 'H').to_s.must_equal %(<label>H</label>)
      builder.input(value: 'some cool answer').to_s.must_equal %(<input value="some cool answer" type="text"/>)
    end

    it 'should raise NoMethodError if element not in set' do
      assert_raises(NoMethodError) { builder.not_an_element }
    end
  end

  describe 'returns html correctly' do
    it '#outputs with block' do
      form = builder.form(action: '/questions/13') do |f|
        concat f.label(class: ['control-label'], content: 'What colour is the sky?')
        concat f.input(type: 'text', value: 'Something exciting')
      end
      form.to_s.must_equal %(<form action="/questions/13" method="post" accept-charset=\"utf-8\"><input name=\"utf8\" type=\"hidden\" value=\"✓\"/><label class="control-label">What colour is the sky?</label><input type="text" value="Something exciting"/></form>)
	end

    it '#outputs without block (use end)' do
      form = builder.form(action: '/questions/13')
      html = form.start
      html << form.label(class: ['control-label'], content: 'What colour is the sky?').to_s
      html << form.input(type: 'text', value: 'Something exciting').to_s
      html << form.end

      html.must_equal %(<form action="/questions/13" method="post" accept-charset=\"utf-8\"><input name=\"utf8\" type=\"hidden\" value=\"✓\"/><label class="control-label">What colour is the sky?</label><input type="text" value="Something exciting"/></form>)
    end

    it '#outputs without string' do
      form = builder.form(content: "<h1>Fab Form</h1>")

      form.to_s.must_equal %(<form method="post" accept-charset=\"utf-8\"><input name=\"utf8\" type=\"hidden\" value=\"✓\"/><h1>Fab Form</h1></form>)
    end
  end

  describe 'builder elements' do
    Password = Class.new(Formular::Element)
    Builder = Class.new(Formular::Builder) do
      element_set(BuilderElement)
    end
    InheritedBuilder = Class.new(Builder)
    PasswordInheritedBuilder = Class.new(InheritedBuilder) do
      element_set(password: Password)
    end

    it "stores elements" do
      Builder.elements.must_equal BuilderElement
    end

    it "inherits elements" do
      InheritedBuilder.elements.must_equal Builder.elements
    end

    it "extends inherited elements" do
      PasswordInheritedBuilder.elements[:password].must_equal Password
    end
  end
end
