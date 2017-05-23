require 'test_helper'
require 'formular/builders/foundation6'
require 'formular/element/foundation6'

describe Formular::Element::Foundation6 do
  let(:builder) { Formular::Builders::Foundation6.new }
  let(:collection_array) { COLLECTION_ARRAY }

  describe Formular::Element::Foundation6::ErrorNotification do
    let(:builder) { Formular::Builders::Foundation6.new(errors: { name: ['some error'] }) }

    it 'default message' do
      element = builder.error_notification
      element.to_s.must_equal %(<div class="callout alert">Please review the problems below:</div>)
    end

    it 'custom message' do
      element = builder.error_notification(message: 'My message:')
      element.to_s.must_equal %(<div class="callout alert">My message:</div>)
    end

    it 'respects html attributes' do
      element = builder.error_notification(data: { some_key: 'true' }, class: ['hey', 'there'])
      element.to_s.must_equal %(<div data-some-key="true" class="hey there callout alert">Please review the problems below:</div>)
    end
  end

  describe Formular::Element::Foundation6::Input do
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

  describe Formular::Element::Foundation6::File do
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

  describe Formular::Element::Foundation6::Submit do
    it "#to_s" do
      builder.submit(content: "Submit!").to_s.must_equal %(<button class="success button" type="submit">Submit!</button>)
    end
  end
end
