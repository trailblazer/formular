require 'test_helper'
require 'formular/elements'
require 'formular/builders/basic'

describe 'core elements' do
  let(:builder) { Formular::Builders::Basic.new }

  describe Formular::Elements::Button do
    it 'returns correct html' do
      element = Formular::Elements::Button.(href: '/some_path', value: 'Button')
      element.to_s.must_equal %(<button href="/some_path">Button</button>)
    end
  end # Formular::Elements::Button

  describe Formular::Elements::Submit do
    it '#to_s' do
      element = Formular::Elements::Submit.(value: 'Submit Button')
      element.to_s.must_equal %(<input type="submit" value="Submit Button"/>)
    end
  end # Formular::Elements::Submit

  describe Formular::Elements::Fieldset do
    it '#to_s contents as string' do
      element = Formular::Elements::Fieldset.(content: '<legend>Hello</legend>')
      element.to_s.must_equal %(<fieldset><legend>Hello</legend></fieldset>)
    end

    it '#to_s contents as block' do
      element = Formular::Elements::Fieldset.() do |_, output|
        output.concat '<legend>Hello</legend>'
        output.concat Formular::Elements::Label.(
          class: ['control-label'],
          content: 'A handy label'
        )
      end
      element.to_s.must_equal %(<fieldset><legend>Hello</legend><label class="control-label">A handy label</label></fieldset>)
    end

    describe 'no contents' do
      let(:element) { Formular::Elements::Fieldset.(class: ['grouping']) }

      it '#to_s' do
        element.to_s.must_equal %(<fieldset class="grouping">)
      end

      it '#end' do
        element.end.must_equal %(</fieldset>)
      end
    end
  end # Formular::Elements::Fieldset

  describe Formular::Elements::Form do
    it '#to_s contents as string' do
      element = Formular::Elements::Form.(content: '<h1>Edit Form</h1>')
      element.to_s.must_equal %(<form method="post"><h1>Edit Form</h1></form>)
    end

    it '#to_s contents as block' do
      element = Formular::Elements::Form.() do |_, output|
        output.concat '<h1>Edit Form</h1>'
        output.concat Formular::Elements::Label.(
          class: ['control-label'],
          content: 'A handy label'
        )
      end
      element.to_s.must_equal %(<form method="post"><h1>Edit Form</h1><label class="control-label">A handy label</label></form>)
    end

    describe 'no contents' do
      let(:element) do
        Formular::Elements::Form.(method: 'put', class: ['grouping'])
      end

      it '#to_s' do
        element.to_s.must_equal %(<form method="put" class="grouping">)
      end

      it '#end' do
        element.end.must_equal %(</form>)
      end
    end
  end # Formular::Elements::Form

  describe Formular::Elements::Textarea do
    it '#to_s contents as string' do
      element = Formular::Elements::Textarea.(content: 'Some lovely words here...')
      element.to_s.must_equal %(<textarea>Some lovely words here...</textarea>)
    end

    it '#to_s contents as block' do
      element = Formular::Elements::Textarea.() do |_, output|
        output.concat 'Part 1 text; '
        output.concat 'Part 2 text'
      end
      element.to_s.must_equal %(<textarea>Part 1 text; Part 2 text</textarea>)
    end

    describe 'no contents' do
      let(:element) { Formular::Elements::Textarea.(rows: 3) }

      it '#to_s' do
        element.to_s.must_equal %(<textarea rows="3"></textarea>)
      end
    end
  end # Formular::Elements::Textarea

  describe Formular::Elements::Input do
    describe 'through builder' do
      it 'with attribute_name' do
        element = builder.input(:body, value: 'Some text')
        element.to_s.must_equal %(<input name="body" id="body" type="text" value="Some text"/>)
      end

      it 'without attribute_name' do
        element = builder.input(value: 'Some text')
        element.to_s.must_equal %(<input type="text" value="Some text"/>)
      end
    end

    it '#to_s' do
      element = Formular::Elements::Input.(value: 'Some text')
      element.to_s.must_equal %(<input type="text" value="Some text"/>)
    end
  end # Formular::Elements::Input

  describe Formular::Elements::Label do
    describe 'through builder' do
      it 'with attribute_name' do
        element = builder.label(:body, content: 'Body')
        element.to_s.must_equal %(<label for="body">Body</label>)
      end

      it 'without attribute_name' do
        element = builder.label(for: 'some_element_id', content: 'Body')
        element.to_s.must_equal %(<label for="some_element_id">Body</label>)
      end
    end

    it '#to_s contents as string' do
      element = Formular::Elements::Label.(content: 'What a nice label')
      element.to_s.must_equal %(<label>What a nice label</label>)
    end

    it '#to_s contents as block' do
      element = Formular::Elements::Label.() do |_, output|
        output.concat 'something '
        output.concat 'super '
        output.concat 'dooper'
      end
      element.to_s.must_equal %(<label>something super dooper</label>)
    end

    describe 'no contents' do
      let(:element) { Formular::Elements::Label.(class: ['control-label']) }

      it '#to_s' do
        element.to_s.must_equal %(<label class="control-label">)
      end

      it '#end' do
        element.end.must_equal %(</label>)
      end
    end
  end # Formular::Elements::Label

  describe Formular::Elements::Checkbox do
    it '#to_s unchecked' do
      element = Formular::Elements::Checkbox.(name: 'public', value: 1)
      element.to_s.must_equal %(<input type="checkbox" name="public" value="1"/>)
    end

    it '#to_s checked' do
      element = Formular::Elements::Checkbox.(name: 'public', value: 1, checked: 'checked')
      element.to_s.must_equal %(<input type="checkbox" name="public" value="1" checked="checked"/>)
    end
  end # Formular::Elements::Checkbox

  describe Formular::Elements::Radio do
    it '#to_s unchecked' do
      element = Formular::Elements::Radio.(name: 'public', value: 1)
      element.to_s.must_equal %(<input type="radio" name="public" value="1"/>)
    end

    it '#to_s checked' do
      element = Formular::Elements::Radio.(name: 'public', value: 1, checked: 'checked')
      element.to_s.must_equal %(<input type="radio" name="public" value="1" checked="checked"/>)
    end
  end # Formular::Elements::Radio

  describe Formular::Elements::Select do
    let(:element) do
      Formular::Elements::Select.(
        name: 'public',
        collection: [[0, 'False'], [1, 'True']],
        value: 0
      )
    end

    it '#to_s' do
      element.to_s.must_equal %(<select name="public"><option value="0" selected="selected">False</option><option value="1">True</option></select>)
    end

    describe '#option_tags' do
      it 'simple array' do
        element.option_tags.must_equal %(<option value="0" selected="selected">False</option><option value="1">True</option>)
      end

      it 'nested array' do
        element = Formular::Elements::Select.(
          name: 'public',
          collection: [
            ['Genders', [%w(m Male), %w(f Female)]],
            ['Booleans', [[1, 'True'], [0, 'False']]]
          ],
          value: 'm'
        )
        element.option_tags.must_equal %(<optgroup label="Genders"><option value="m" selected="selected">Male</option><option value="f">Female</option></optgroup><optgroup label="Booleans"><option value="1">True</option><option value="0">False</option></optgroup>)
      end
    end
  end # Formular::Elements::Select
end
