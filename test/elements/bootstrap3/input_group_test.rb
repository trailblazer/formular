require 'test_helper'
require 'formular/builders/bootstrap3'
require 'formular/elements/bootstrap3'
require 'formular/elements/bootstrap3/input_group'

describe 'Bootstrap3::InputGroup' do
  let(:builder) { Formular::Builders::Bootstrap3.new }

  it '#to_s with addons as options' do
    element = builder.input_group(
      :url,
      label: 'URL',
      left_addon: 'http://',
      right_addon: '.com',
      value: 'www.trailblazer.to'
    )
    element.to_s.must_equal %(<div class="form-group"><label for="url" class="control-label">URL</label><div class="input-group"><span class="input-group-addon">http://</span><input value="www.trailblazer.to" name="url" id="url" type="text" class="form-control"/><span class="input-group-addon">.com</span></div></div>)
  end

  describe 'with buttons as options' do
    it 'to_s with buttons as options' do
      element = builder.input_group(
        :url,
        label: 'URL',
        left_btn: '<a class="btn btn-default" href="/some_path">Click Me</a>',
        right_btn: '<a class="btn btn-default" href="/some_path">Click Me</a>',
        value: 'www.trailblazer.to'
      )
      element.to_s.must_equal %(<div class="form-group"><label for="url" class="control-label">URL</label><div class="input-group"><span class="input-group-btn"><a class="btn btn-default" href="/some_path">Click Me</a></span><input value="www.trailblazer.to" name="url" id="url" type="text" class="form-control"/><span class="input-group-btn"><a class="btn btn-default" href="/some_path">Click Me</a></span></div></div>)
    end
  end

  it '#to_s with block' do
    element = builder.input_group(:title, label: 'Title', value: 'John Smith') do |input|
      concat input.group_addon('<input name="default[]" id="default" type="checkbox" value="1">')
      concat input.control
      concat input.group_btn(builder.submit(value: 'Go!'))
    end
    element.to_s.must_equal %(<div class="form-group"><label for="title" class="control-label">Title</label><div class="input-group"><span class="input-group-addon"><input name="default[]" id="default" type="checkbox" value="1"></span><input value="John Smith" name="title" id="title" type="text" class="form-control"/><span class="input-group-btn"><button class="btn btn-default" type="submit">Go!</button></span></div></div>)
  end
end