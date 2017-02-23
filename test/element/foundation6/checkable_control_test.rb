require 'test_helper'
require 'formular/builders/foundation6'
require 'formular/element/foundation6'
require 'formular/element/foundation6/checkable_control'

describe 'Foundation6::CheckableControl' do
  let(:builder) { Formular::Builders::Foundation6.new }
  let(:collection_array) { COLLECTION_ARRAY }

  describe Formular::Element::Foundation6::Checkbox do
    it '#to_s' do
      element = builder.checkbox(:public, label: 'Public')
      element.to_s.must_equal %(<fieldset><input value="0" name="public" type="hidden"/><label><input name="public" id="public" type="checkbox" value="1"/> Public</label></fieldset>)
    end

    it '#to_s with errors' do
      element = builder.checkbox(
        :public,
        label: 'Option 1',
        error: 'Something terrible happened'
      )
      element.to_s.must_equal %(<fieldset><input value="0" name="public" type="hidden"/><label class="is-invalid-label"><input name="public" id="public" type="checkbox" value="1"/> Option 1</label><span class="form-error is-visible">Something terrible happened</span></fieldset>)
    end

    describe 'with collection' do
      it '#to_s' do
        element = builder.checkbox(
          :public,
          label: 'Public',
          collection: collection_array
        )
        element.to_s.must_equal %(<fieldset><legend>Public</legend><label><input type="checkbox" value="1" name="public[]" id="public_1"/> Option 1</label><label><input type="checkbox" value="2" name="public[]" id="public_2"/> Option 2</label><input value="" name="public[]" type="hidden"/></fieldset>)
      end

      it '#to_s with errors' do
        element = builder.checkbox(
          :public,
          collection: collection_array,
          error: 'Something terrible happened'
        )
        element.to_s.must_equal %(<fieldset><label class="is-invalid-label"><input type="checkbox" value="1" name="public[]" id="public_1"/> Option 1</label><label class="is-invalid-label"><input type="checkbox" value="2" name="public[]" id="public_2"/> Option 2</label><input value="" name="public[]" type="hidden"/><span class="form-error is-visible">Something terrible happened</span></fieldset>)
      end
    end
  end

  describe Formular::Element::Foundation6::Radio do
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

  describe Formular::Element::Foundation6::StackedCheckbox do
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
        element.to_s.must_equal %(<fieldset><div><label><input type="checkbox" value="1" name="public[]" id="public_1"/> Option 1</label></div><div><label><input type="checkbox" value="2" name="public[]" id="public_2"/> Option 2</label></div><input value="" name="public[]" type="hidden"/></fieldset>)
      end

      it '#to_s with errors' do
        element = builder.stacked_checkbox(
          :public,
          collection: collection_array,
          error: 'Something terrible happened'
        )
        element.to_s.must_equal %(<fieldset><div><label class="is-invalid-label"><input type="checkbox" value="1" name="public[]" id="public_1"/> Option 1</label></div><div><label class="is-invalid-label"><input type="checkbox" value="2" name="public[]" id="public_2"/> Option 2</label></div><input value="" name="public[]" type="hidden"/><span class="form-error is-visible">Something terrible happened</span></fieldset>)
      end
    end
  end

  describe Formular::Element::Foundation6::StackedRadio do
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
end