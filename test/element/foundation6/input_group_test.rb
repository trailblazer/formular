require 'test_helper'
require 'formular/builders/foundation6'
require 'formular/element/foundation6'
require 'formular/element/foundation6/input_group'

describe 'Foundation6::InputGroup' do
  let(:builder) { Formular::Builders::Foundation6.new }

  it "labels as options" do
    element = builder.input_group(
      :url,
      left_label: 'http://',
      right_label: '.com',
      value: 'www.trailblazer.to'
    )
    element.to_s.must_equal %(<fieldset><div class="input-group"><span class="input-group-label">http://</span><input value="www.trailblazer.to" name="url" id="url" type="text" class="input-group-field"/><span class="input-group-label">.com</span></div></fieldset>)
  end

  it 'to_s with buttons as options' do
    element = builder.input_group(
      :url,
      left_button: '<button class="button" href="/some_path">Click Me</button>',
      right_button: '<button class="button" href="/some_path">Click Me</button>',
      value: 'www.trailblazer.to'
    )
    element.to_s.must_equal %(<fieldset><div class="input-group"><div class="input-group-button"><button class="button" href="/some_path">Click Me</button></div><input value="www.trailblazer.to" name="url" id="url" type="text" class="input-group-field"/><div class="input-group-button"><button class="button" href="/some_path">Click Me</button></div></div></fieldset>)
  end

  it '#to_s with block' do
    element = builder.input_group(:title, value: 'John Smith') do |input|
      concat input.group_label('<input name="default[]" id="default" type="checkbox" value="1">')
      concat input.group_input
      concat input.group_button(builder.submit(content: 'Go!'))
    end
    element.to_s.must_equal %(<fieldset><div class="input-group"><span class="input-group-label"><input name="default[]" id="default" type="checkbox" value="1"></span><input value="John Smith" name="title" id="title" type="text" class="input-group-field"/><div class="input-group-button"><button class="success button" type="submit">Go!</button></div></div></fieldset>)
  end

  describe "with group label" do
    it "labels as options" do
      element = builder.input_group(
        :url,
        label: 'Url',
        left_label: 'http://',
        right_label: '.com',
        value: 'www.trailblazer.to'
      )
      element.to_s.must_equal %(<fieldset><label for="url">Url</label><div class="input-group"><span class="input-group-label">http://</span><input value="www.trailblazer.to" name="url" id="url" type="text" class="input-group-field"/><span class="input-group-label">.com</span></div></fieldset>)
    end

    it 'to_s with buttons as options' do
      element = builder.input_group(
        :url,
        label: 'Url',
        left_button: '<button class="button" href="/some_path">Click Me</button>',
        right_button: '<button class="button" href="/some_path">Click Me</button>',
        value: 'www.trailblazer.to'
      )
      element.to_s.must_equal %(<fieldset><label for="url">Url</label><div class="input-group"><div class="input-group-button"><button class="button" href="/some_path">Click Me</button></div><input value="www.trailblazer.to" name="url" id="url" type="text" class="input-group-field"/><div class="input-group-button"><button class="button" href="/some_path">Click Me</button></div></div></fieldset>)
    end

    it '#to_s with block' do
      element = builder.input_group(:title, value: 'John Smith', label: 'Title') do |input|
        concat input.group_label('<input name="default[]" id="default" type="checkbox" value="1">')
        concat input.group_input
        concat input.group_button(builder.submit(content: 'Go!'))
      end
      element.to_s.must_equal %(<fieldset><label for="title">Title</label><div class="input-group"><span class="input-group-label"><input name="default[]" id="default" type="checkbox" value="1"></span><input value="John Smith" name="title" id="title" type="text" class="input-group-field"/><div class="input-group-button"><button class="success button" type="submit">Go!</button></div></div></fieldset>)
    end
  end

  describe "with errors" do
    let(:builder) { Formular::Builders::Foundation6.new(errors: { url: ['Try harder!!'], title: ['is missing'] }) }

    it "labels as options" do
      element = builder.input_group(
        :url,
        left_label: 'http://',
        right_label: '.com',
        value: 'www.trailblazer.to'
      )
      element.to_s.must_equal %(<fieldset><div class="input-group"><span class="is-invalid-label input-group-label">http://</span><input value="www.trailblazer.to" name="url" id="url" type="text" class="input-group-field is-invalid-input"/><span class="is-invalid-label input-group-label">.com</span></div><span class="form-error is-visible">Try harder!!</span></fieldset>)
    end

    it 'to_s with buttons as options' do
      element = builder.input_group(
        :url,
        left_button: '<button class="button" href="/some_path">Click Me</button>',
        right_button: '<button class="button" href="/some_path">Click Me</button>',
        value: 'www.trailblazer.to'
      )
      element.to_s.must_equal %(<fieldset><div class="input-group"><div class="input-group-button"><button class="button" href="/some_path">Click Me</button></div><input value="www.trailblazer.to" name="url" id="url" type="text" class="input-group-field is-invalid-input"/><div class="input-group-button"><button class="button" href="/some_path">Click Me</button></div></div><span class="form-error is-visible">Try harder!!</span></fieldset>)
    end

    it '#to_s with block' do
      element = builder.input_group(:title, value: 'John Smith') do |input|
        concat input.group_label('<input name="default[]" id="default" type="checkbox" value="1">')
        concat input.group_input
        concat input.group_button(builder.submit(content: 'Go!'))
      end
      element.to_s.must_equal %(<fieldset><div class="input-group"><span class="is-invalid-label input-group-label"><input name="default[]" id="default" type="checkbox" value="1"></span><input value="John Smith" name="title" id="title" type="text" class="input-group-field is-invalid-input"/><div class="input-group-button"><button class="success button" type="submit">Go!</button></div></div><span class="form-error is-visible">is missing</span></fieldset>)
    end
  end

  describe "with hint" do
    it "labels as options" do
      element = builder.input_group(
        :url,
        left_label: 'http://',
        right_label: '.com',
        value: 'www.trailblazer.to',
        hint: 'Some handy hint'
      )
      element.to_s.must_equal %(<fieldset><div class="input-group"><span class="input-group-label">http://</span><input value="www.trailblazer.to" name="url" id="url" type="text" aria-describedby=\"url_hint\" class="input-group-field"/><span class="input-group-label">.com</span></div><p id="url_hint" class="help-text">Some handy hint</p></fieldset>)
    end

    it 'to_s with buttons as options' do
      element = builder.input_group(
        :url,
        left_button: '<button class="button" href="/some_path">Click Me</button>',
        right_button: '<button class="button" href="/some_path">Click Me</button>',
        value: 'www.trailblazer.to',
        hint: 'Some handy hint'
      )
      element.to_s.must_equal %(<fieldset><div class="input-group"><div class="input-group-button"><button class="button" href="/some_path">Click Me</button></div><input value="www.trailblazer.to" name="url" id="url" type="text" aria-describedby=\"url_hint\" class="input-group-field"/><div class="input-group-button"><button class="button" href="/some_path">Click Me</button></div></div><p id="url_hint" class="help-text">Some handy hint</p></fieldset>)
    end

    it '#to_s with block' do
      element = builder.input_group(:title, value: 'John Smith', hint: 'Some handy hint') do |input|
        concat input.group_label('<input name="default[]" id="default" type="checkbox" value="1">')
        concat input.group_input
        concat input.group_button(builder.submit(content: 'Go!'))
      end
      element.to_s.must_equal %(<fieldset><div class="input-group"><span class="input-group-label"><input name="default[]" id="default" type="checkbox" value="1"></span><input value="John Smith" name="title" id="title" type="text" aria-describedby=\"title_hint\" class="input-group-field"/><div class="input-group-button"><button class="success button" type="submit">Go!</button></div></div><p id="title_hint" class="help-text">Some handy hint</p></fieldset>)
    end
  end

  describe "all together!" do
    let(:builder) { Formular::Builders::Foundation6.new(errors: { url: ['Try harder!!'], title: ['is missing'] }) }

    it "labels as options" do
      element = builder.input_group(
        :url,
        label: 'Url',
        left_label: 'http://',
        right_label: '.com',
        value: 'www.trailblazer.to',
        hint: 'Some handy hint'
      )
      element.to_s.must_equal %(<fieldset><label class="is-invalid-label" for="url">Url</label><div class="input-group"><span class="is-invalid-label input-group-label">http://</span><input value="www.trailblazer.to" name="url" id="url" type="text" aria-describedby=\"url_hint\" class="input-group-field is-invalid-input"/><span class="is-invalid-label input-group-label">.com</span></div><p id="url_hint" class="help-text">Some handy hint</p><span class="form-error is-visible">Try harder!!</span></fieldset>)
    end

    it 'to_s with buttons as options' do
      element = builder.input_group(
        :url,
        label: 'Url',
        left_button: '<button class="button" href="/some_path">Click Me</button>',
        right_button: '<button class="button" href="/some_path">Click Me</button>',
        value: 'www.trailblazer.to',
        hint: 'Some handy hint'
      )
      element.to_s.must_equal %(<fieldset><label class="is-invalid-label" for="url">Url</label><div class="input-group"><div class="input-group-button"><button class="button" href="/some_path">Click Me</button></div><input value="www.trailblazer.to" name="url" id="url" type="text" aria-describedby=\"url_hint\" class="input-group-field is-invalid-input"/><div class="input-group-button"><button class="button" href="/some_path">Click Me</button></div></div><p id="url_hint" class="help-text">Some handy hint</p><span class="form-error is-visible">Try harder!!</span></fieldset>)
    end

    it '#to_s with block' do
      element = builder.input_group(:title, label: 'Title', value: 'John Smith', hint: 'Some handy hint') do |input|
        concat input.group_label('<input name="default[]" id="default" type="checkbox" value="1">')
        concat input.group_input
        concat input.group_button(builder.submit(content: 'Go!'))
      end
      element.to_s.must_equal %(<fieldset><label class="is-invalid-label" for="title">Title</label><div class="input-group"><span class="is-invalid-label input-group-label"><input name="default[]" id="default" type="checkbox" value="1"></span><input value="John Smith" name="title" id="title" type="text" aria-describedby=\"title_hint\" class="input-group-field is-invalid-input"/><div class="input-group-button"><button class="success button" type="submit">Go!</button></div></div><p id="title_hint" class="help-text">Some handy hint</p><span class="form-error is-visible">is missing</span></fieldset>)
    end
  end
end