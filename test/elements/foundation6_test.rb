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

  describe Formular::Elements::Foundation6::Checkbox do
    it '#to_s' do
      element = builder.checkbox(:public, value: 1, label: 'Public')
      element.to_s.must_equal %(<fieldset><input value="0" name="public" type="hidden"/><label><input value="1" name="public" id="public" type="checkbox"/> Public</label></fieldset>)
    end

    it '#to_s with errors' do
      element = builder.checkbox(
        :public,
        value: 1,
        label: 'Option 1',
        error: 'Something terrible happened'
      )
      element.to_s.must_equal %(<fieldset><input value="0" name="public" type="hidden"/><label class="is-invalid-label"><input value="1" name="public" id="public" type="checkbox"/> Option 1</label><span class="form-error is-visible">Something terrible happened</span></fieldset>)
    end

    describe 'with collection' do
      it '#to_s' do
        element = builder.checkbox(
          :public,
          label: 'Public',
          collection: collection_array
        )
        element.to_s.must_equal %(<fieldset><legend>Public</legend><label><input type="checkbox" name="public[]" value="1" id="public_1"/> Option 1</label><label><input type="checkbox" name="public[]" value="2" id="public_2"/> Option 2</label><input value="" name="public[]" type="hidden"/></fieldset>)
      end

      it '#to_s with errors' do
        element = builder.checkbox(
          :public,
          collection: collection_array,
          error: 'Something terrible happened'
        )
        element.to_s.must_equal %(<fieldset><label class="is-invalid-label"><input type="checkbox" name="public[]" value="1" id="public_1"/> Option 1</label><label class="is-invalid-label"><input type="checkbox" name="public[]" value="2" id="public_2"/> Option 2</label><input value="" name="public[]" type="hidden"/><span class="form-error is-visible">Something terrible happened</span></fieldset>)
      end
    end
  end

  describe Formular::Elements::Foundation6::Radio do
    it '#to_s' do
      element = builder.radio(:public, value: true, label: 'Public')
      element.to_s.must_equal %(<fieldset><label><input value="true" name="public" id="public" type="radio"/> Public</label></fieldset>)
    end

    it '#to_s with errors' do
      element = builder.radio(
        :public,
        value: 1,
        label: 'Option 1',
        error: 'Something terrible happened'
      )
      element.to_s.must_equal %(<fieldset><label class="is-invalid-label"><input value="1" name="public" id="public" type="radio"/> Option 1</label><span class="form-error is-visible">Something terrible happened</span></fieldset>)
    end

    describe 'with collection' do
      it '#to_s' do
        element = builder.radio(:public, collection: collection_array)
        element.to_s.must_equal %(<fieldset><label><input type="radio" name="public" value="1" id="public_1"/> Option 1</label><label><input type="radio" name="public" value="2" id="public_2"/> Option 2</label></fieldset>)
      end

      it '#to_s with errors' do
        element = builder.radio(
          :public,
          collection: collection_array,
          error: 'Something terrible happened'
        )
        element.to_s.must_equal %(<fieldset><label class="is-invalid-label"><input type="radio" name="public" value="1" id="public_1"/> Option 1</label><label class="is-invalid-label"><input type="radio" name="public" value="2" id="public_2"/> Option 2</label><span class="form-error is-visible">Something terrible happened</span></fieldset>)
      end
    end
  end

  describe Formular::Elements::Foundation6::StackedCheckbox do
    it '#to_s' do
      element = builder.stacked_checkbox(:public, value: 1, label: 'Public')
      element.to_s.must_equal %(<fieldset><input value="0" name="public" type="hidden"/><div><label><input value="1" name="public" id="public" type="checkbox"/> Public</label></div></fieldset>)
    end

    it '#to_s with errors' do
      element = builder.stacked_checkbox(
        :public,
        value: 1,
        label: 'Option 1',
        error: 'Something terrible happened'
      )
      element.to_s.must_equal %(<fieldset><input value="0" name="public" type="hidden"/><div><label class="is-invalid-label"><input value="1" name="public" id="public" type="checkbox"/> Option 1</label></div><span class="form-error is-visible">Something terrible happened</span></fieldset>)
    end

    describe 'with collection' do
      it '#to_s' do
        element = builder.stacked_checkbox(
          :public,
          collection: collection_array
        )
        element.to_s.must_equal %(<fieldset><div><label><input type="checkbox" name="public[]" value="1" id="public_1"/> Option 1</label></div><div><label><input type="checkbox" name="public[]" value="2" id="public_2"/> Option 2</label></div><input value="" name="public[]" type="hidden"/></fieldset>)
      end

      it '#to_s with errors' do
        element = builder.stacked_checkbox(
          :public,
          collection: collection_array,
          error: 'Something terrible happened'
        )
        element.to_s.must_equal %(<fieldset><div><label class="is-invalid-label"><input type="checkbox" name="public[]" value="1" id="public_1"/> Option 1</label></div><div><label class="is-invalid-label"><input type="checkbox" name="public[]" value="2" id="public_2"/> Option 2</label></div><input value="" name="public[]" type="hidden"/><span class="form-error is-visible">Something terrible happened</span></fieldset>)
      end
    end
  end

  describe Formular::Elements::Foundation6::StackedRadio do
    it '#to_s' do
      element = builder.stacked_radio(:public, value: true, label: 'Public')
      element.to_s.must_equal %(<fieldset><div><label><input value="true" name="public" id="public" type="radio"/> Public</label></div></fieldset>)
    end

    it '#to_s with errors' do
      element = builder.stacked_radio(
        :public,
        value: 1,
        label: 'Option 1',
        error: 'Something terrible happened'
      )
      element.to_s.must_equal %(<fieldset><div><label class="is-invalid-label"><input value="1" name="public" id="public" type="radio"/> Option 1</label></div><span class="form-error is-visible">Something terrible happened</span></fieldset>)
    end

    describe 'with collection' do
      it '#to_s' do
        element = builder.stacked_radio(
          :public,
          collection: collection_array
        )
        element.to_s.must_equal %(<fieldset><div><label><input type="radio" name="public" value="1" id="public_1"/> Option 1</label></div><div><label><input type="radio" name="public" value="2" id="public_2"/> Option 2</label></div></fieldset>)
      end

      it '#to_s with errors' do
        element = builder.stacked_radio(
          :public,
          collection: collection_array,
          error: 'Something terrible happened'
        )
        element.to_s.must_equal %(<fieldset><div><label class="is-invalid-label"><input type="radio" name="public" value="1" id="public_1"/> Option 1</label></div><div><label class="is-invalid-label"><input type="radio" name="public" value="2" id="public_2"/> Option 2</label></div><span class="form-error is-visible">Something terrible happened</span></fieldset>)
      end
    end
  end

  describe Formular::Elements::Foundation6::Submit do
    it "#to_s" do
      builder.submit(value: "Submit!").to_s.must_equal %(<button class="success button" type="submit">Submit!</button>)
    end
  end
end
