require 'test_helper'
require 'formular/builder'
require 'formular/elements'

describe Formular::Builder do
  let(:builder) {
    Formular::Builder.new(
      label: Formular::Elements::Label,
      input: Formular::Elements::Input,
      form: Formular::Elements::Form
    )
  }

  describe '#define_element_methods' do
    it 'should pass self to element' do
      builder.label(content: 'H').builder.must_equal builder
    end

    it 'should call correct element' do
      builder.label(content: 'H').to_s.must_equal %(<label>H</label>)
      builder.input(value: 'some cool answer').to_s.must_equal %(<input type="text" value="some cool answer"/>)
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
      form.to_s.must_equal %(<form method="post" action="/questions/13"><label class="control-label">What colour is the sky?</label><input type="text" value="Something exciting"/></form>)
    end

    it '#outputs without block (use end)' do
      form = builder.form(action: '/questions/13', method: 'put')
      html = form.to_s
      html << form.label(class: ['control-label'], content: 'What colour is the sky?').to_s
      html << form.input(type: 'text', value: 'Something exciting').to_s
      html << form.end

      html.must_equal %(<form method="put" action="/questions/13"><label class="control-label">What colour is the sky?</label><input type="text" value="Something exciting"/></form>)
    end

    it '#outputs without string' do
      form = builder.form(content: "<h1>Fab Form</h1>")

      form.to_s.must_equal %(<form method="post"><h1>Fab Form</h1></form>)
    end
  end
end
