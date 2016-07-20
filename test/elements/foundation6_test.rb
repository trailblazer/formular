require 'test_helper'
require 'formular/builders/foundation6'
require 'formular/elements/foundation6'

describe Formular::Elements::Foundation6 do
  let(:builder) { Formular::Builders::Foundation6.new }
  let(:collection_array) { [['Option 1', 1], ['Option 2', 2]] }

  describe Formular::Elements::Foundation6::Input do
    it '#to_s' do
      element = builder.input(:name, label: 'Name', value: 'Joseph Smith')
      element.to_s.must_equal %(<label>Name<input value="Joseph Smith" name="name" id="name" type="text"/></label>)
    end

    it '#to_s with errors' do
      element = builder.input(
        :name,
        label: 'Name',
        value: 'Joseph Smith',
        error: 'Something terrible happened'
      )
      element.to_s.must_equal %(<label class="is-invalid-label">Name<input value="Joseph Smith" name="name" id="name" type="text" class="is-invalid-input"/><span class="form-error is-visible">Something terrible happened</span></label>)
    end

    it '#to_s with hint' do
      element = builder.input(
        :name,
        label: 'Name',
        value: 'Joseph Smith',
        hint: 'Something helpful'
      )
      element.to_s.must_equal %(<label>Name<input value="Joseph Smith" name="name" id="name" type="text" aria-describedby="name_hint"/><p id="name_hint" class="help-text">Something helpful</p></label>)
    end
  end

  describe Formular::Elements::Foundation6::File do
    it '#to_s' do
      element = builder.file(:file, label: 'File Upload')
      element.to_s.must_equal %(<label class="button" for="file">File Upload</label><input name="file" id="file" type="file" class="show-for-sr"/>)
    end

    it '#to_s with errors' do
      element = builder.file(
        :file,
        label: 'File Upload',
        error: 'Something terrible happened'
      )
      element.to_s.must_equal %(<label class="button" for="file">File Upload</label><input name="file" id="file" type="file" class="show-for-sr"/><span class="form-error is-visible">Something terrible happened</span>)
    end
  end

  describe Formular::Elements::Foundation6::Submit do
    it "#to_s" do
      builder.submit(value: "Submit!").to_s.must_equal %(<button class="success button" type="submit">Submit!</button>)
    end
  end
end
