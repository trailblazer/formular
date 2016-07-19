require 'test_helper'
require 'formular/builders/bootstrap3'
require 'formular/elements/bootstrap3'
require 'formular/elements/bootstrap3/checkable_controls'

describe 'Bootstrap3::CheckableControls' do
  let(:builder) { Formular::Builders::Bootstrap3.new }
  let(:collection_array) { [['Option 1', 1], ['Option 2', 2]] }

  describe Formular::Elements::Bootstrap3::Checkbox do
    it 'with value and label' do
      element = builder.checkbox(:public, label: 'Public', value: 1)
      element.to_s.must_equal %(<div class="form-group"><input type="hidden" value="0" name="public"/><div class="checkbox"><label><input name="public" id="public" type="checkbox" value="1"/> Public</label></div></div>)
    end

    it 'with hint' do
      element = builder.checkbox(
        :public,
        label: 'Public',
        value: 1,
        hint: 'Some helpful words'
      )
      element.to_s.must_equal %(<div class="form-group"><input type="hidden" value="0" name="public"/><div class="checkbox"><label><input name="public" id="public" type="checkbox" aria-describedby="public_hint" value="1"/> Public</label></div><span class="help-block" id="public_hint">Some helpful words</span></div>)
    end

    it 'with error' do
      element = builder.checkbox(
        :public,
        label: 'Public',
        value: 1,
        error: 'Something nasty happened'
      )
      element.to_s.must_equal %(<div class="form-group has-error"><input type="hidden" value="0" name="public"/><div class="checkbox"><label><input name="public" id="public" type="checkbox" value="1"/> Public</label></div><span class="help-block">Something nasty happened</span></div>)
    end

    it 'all together!' do
      element = builder.checkbox(
        :public,
        label: 'Public',
        value: 1,
        error: 'Something nasty happened',
        hint: 'Some helpful words'
      )
      element.to_s.must_equal %(<div class="form-group has-error"><input type="hidden" value="0" name="public"/><div class="checkbox"><label><input name="public" id="public" type="checkbox" aria-describedby="public_hint" value="1"/> Public</label></div><span class="help-block" id="public_hint">Some helpful words</span><span class="help-block">Something nasty happened</span></div>)
    end

    describe 'with collection' do
      it 'no group label' do
        element = builder.checkbox(:public, collection: collection_array)
        element.to_s.must_equal %(<div class="form-group"><div class="checkbox"><label><input name="public[]" id="public_1" type="checkbox" value="1"/> Option 1</label></div><div class="checkbox"><label><input name="public[]" id="public_2" type="checkbox" value="2"/> Option 2</label></div><input type="hidden" value="" name="public[]"/></div>)
      end

      it 'with group label' do
        element = builder.checkbox(
          :public,
          label: 'Public',
          collection: collection_array
        )
        element.to_s.must_equal %(<div class="form-group"><label class="control-label">Public</label><div class="checkbox"><label><input name="public[]" id="public_1" type="checkbox" value="1"/> Option 1</label></div><div class="checkbox"><label><input name="public[]" id="public_2" type="checkbox" value="2"/> Option 2</label></div><input type="hidden" value="" name="public[]"/></div>)
      end

      it 'with hint' do
        element = builder.checkbox(
          :public,
          collection: collection_array,
          hint: 'Some helpful words'
        )
        element.to_s.must_equal %(<div class="form-group"><div class="checkbox"><label><input name="public[]" id="public_1" type="checkbox" aria-describedby="public_hint" value="1"/> Option 1</label></div><div class="checkbox"><label><input name="public[]" id="public_2" type="checkbox" aria-describedby="public_hint" value="2"/> Option 2</label></div><input type="hidden" value="" name="public[]"/><span class="help-block" id="public_hint">Some helpful words</span></div>)
      end

      it 'with error' do
        element = builder.checkbox(
          :public,
          collection: collection_array,
          error: 'Something nasty happened'
        )
        element.to_s.must_equal %(<div class="form-group has-error"><div class="checkbox"><label><input name="public[]" id="public_1" type="checkbox" value="1"/> Option 1</label></div><div class="checkbox"><label><input name="public[]" id="public_2" type="checkbox" value="2"/> Option 2</label></div><input type="hidden" value="" name="public[]"/><span class="help-block">Something nasty happened</span></div>)
      end

      it 'all together!' do
        element = builder.checkbox(
          :public,
          label: 'Public',
          collection: collection_array,
          hint: 'Some helpful words',
          error: 'Something nasty happened'
        )
        element.to_s.must_equal %(<div class="form-group has-error"><label class="control-label">Public</label><div class="checkbox"><label><input name="public[]" id="public_1" type="checkbox" aria-describedby="public_hint" value="1"/> Option 1</label></div><div class="checkbox"><label><input name="public[]" id="public_2" type="checkbox" aria-describedby="public_hint" value="2"/> Option 2</label></div><input type="hidden" value="" name="public[]"/><span class="help-block" id="public_hint">Some helpful words</span><span class="help-block">Something nasty happened</span></div>)
      end
    end
  end

  describe Formular::Elements::Bootstrap3::Radio do
    it 'with value and label' do
      element = builder.radio(:public, value: 1, label: 'Public')
      element.to_s.must_equal %(<div class="form-group"><div class="radio"><label><input name="public" id="public" type="radio" value="1"/> Public</label></div></div>)
    end

    it 'with hint' do
      element = builder.radio(
        :public,
        value: 1,
        label: 'Public',
        hint: 'Some helpful words'
      )
      element.to_s.must_equal %(<div class="form-group"><div class="radio"><label><input name="public" id="public" type="radio" aria-describedby="public_hint" value="1"/> Public</label></div><span class="help-block" id="public_hint">Some helpful words</span></div>)
    end

    it 'with error' do
      element = builder.radio(
        :public,
        value: 1,
        label: 'Public',
        error: 'Something nasty happened'
      )
      element.to_s.must_equal %(<div class="form-group has-error"><div class="radio"><label><input name="public" id="public" type="radio" value="1"/> Public</label></div><span class="help-block">Something nasty happened</span></div>)
    end

    it 'all together!' do
      element = builder.radio(
        :public,
        value: 1,
        label: 'Public',
        error: 'Something nasty happened',
        hint: 'Some helpful words'
      )
      element.to_s.must_equal %(<div class="form-group has-error"><div class="radio"><label><input name="public" id="public" type="radio" aria-describedby="public_hint" value="1"/> Public</label></div><span class="help-block" id="public_hint">Some helpful words</span><span class="help-block">Something nasty happened</span></div>)
    end

    describe 'with collection' do
      it 'no group label' do
        element = builder.radio(:public, collection: collection_array)
        element.to_s.must_equal %(<div class="form-group"><div class="radio"><label><input name="public" id="public_1" type="radio" value="1"/> Option 1</label></div><div class="radio"><label><input name="public" id="public_2" type="radio" value="2"/> Option 2</label></div></div>)
      end

      it 'with group label' do
        element = builder.radio(
          :public,
          label: 'Public',
          collection: collection_array
        )
        element.to_s.must_equal %(<div class="form-group"><label class="control-label">Public</label><div class="radio"><label><input name="public" id="public_1" type="radio" value="1"/> Option 1</label></div><div class="radio"><label><input name="public" id="public_2" type="radio" value="2"/> Option 2</label></div></div>)
      end

      it 'with hint' do
        element = builder.radio(
          :public,
          collection: collection_array,
          hint: 'Some helpful words'
        )
        element.to_s.must_equal %(<div class="form-group"><div class="radio"><label><input name="public" id="public_1" type="radio" aria-describedby="public_hint" value="1"/> Option 1</label></div><div class="radio"><label><input name="public" id="public_2" type="radio" aria-describedby="public_hint" value="2"/> Option 2</label></div><span class="help-block" id="public_hint">Some helpful words</span></div>)
      end

      it 'with error' do
        element = builder.radio(
          :public,
          collection: collection_array,
          error: 'Something nasty happened'
        )
        element.to_s.must_equal %(<div class="form-group has-error"><div class="radio"><label><input name="public" id="public_1" type="radio" value="1"/> Option 1</label></div><div class="radio"><label><input name="public" id="public_2" type="radio" value="2"/> Option 2</label></div><span class="help-block">Something nasty happened</span></div>)
      end

      it 'all together!' do
        element = builder.radio(
          :public,
          label: 'Public',
          collection: collection_array,
          hint: 'Some helpful words',
          error: 'Something nasty happened'
        )
        element.to_s.must_equal %(<div class="form-group has-error"><label class="control-label">Public</label><div class="radio"><label><input name="public" id="public_1" type="radio" aria-describedby="public_hint" value="1"/> Option 1</label></div><div class="radio"><label><input name="public" id="public_2" type="radio" aria-describedby="public_hint" value="2"/> Option 2</label></div><span class="help-block" id="public_hint">Some helpful words</span><span class="help-block">Something nasty happened</span></div>)
      end
    end
  end

  describe Formular::Elements::Bootstrap3::InlineCheckbox do
    it 'with value and label' do
      element = builder.inline_checkbox(:public, label: 'Public', value: 1)
      element.to_s.must_equal %(<div class="form-group"><input type="hidden" value="0" name="public"/><label class="checkbox-inline"><input name="public" id="public" type="checkbox" value="1"/> Public</label></div>)
    end

    it 'with hint' do
      element = builder.inline_checkbox(
        :public,
        label: 'Public',
        value: 1,
        hint: 'Some helpful words'
      )
      element.to_s.must_equal %(<div class="form-group"><input type="hidden" value="0" name="public"/><label class="checkbox-inline"><input name="public" id="public" type="checkbox" aria-describedby="public_hint" value="1"/> Public</label><span class="help-block" id="public_hint">Some helpful words</span></div>)
    end

    it 'with error' do
      element = builder.inline_checkbox(
        :public,
        label: 'Public',
        value: 1,
        error: 'Something nasty happened'
      )
      element.to_s.must_equal %(<div class="form-group has-error"><input type="hidden" value="0" name="public"/><label class="checkbox-inline"><input name="public" id="public" type="checkbox" value="1"/> Public</label><span class="help-block">Something nasty happened</span></div>)
    end

    it 'all together!' do
      element = builder.inline_checkbox(
        :public,
        label: 'Public',
        value: 1,
        error: 'Something nasty happened',
        hint: 'Some helpful words'
      )
      element.to_s.must_equal %(<div class="form-group has-error"><input type="hidden" value="0" name="public"/><label class="checkbox-inline"><input name="public" id="public" type="checkbox" aria-describedby="public_hint" value="1"/> Public</label><span class="help-block" id="public_hint">Some helpful words</span><span class="help-block">Something nasty happened</span></div>)
    end

    describe 'with collection' do
      it 'no group label' do
        element = builder.inline_checkbox(:public, collection: collection_array)
        element.to_s.must_equal %(<div class="form-group"><label class="checkbox-inline"><input name="public[]" id="public_1" type="checkbox" value="1"/> Option 1</label><label class="checkbox-inline"><input name="public[]" id="public_2" type="checkbox" value="2"/> Option 2</label><input type="hidden" value="" name="public[]"/></div>)
      end

      it 'with group label' do
        element = builder.inline_checkbox(
          :public,
          label: 'Public',
          collection: collection_array
        )
        element.to_s.must_equal %(<div class="form-group"><label class="control-label">Public</label><div><label class="checkbox-inline"><input name="public[]" id="public_1" type="checkbox" value="1"/> Option 1</label><label class="checkbox-inline"><input name="public[]" id="public_2" type="checkbox" value="2"/> Option 2</label></div><input type="hidden" value="" name="public[]"/></div>)
      end

      it 'with hint' do
        element = builder.inline_checkbox(
          :public,
          collection: collection_array,
          hint: 'Some helpful words'
        )
        element.to_s.must_equal %(<div class="form-group"><label class="checkbox-inline"><input name="public[]" id="public_1" type="checkbox" aria-describedby="public_hint" value="1"/> Option 1</label><label class="checkbox-inline"><input name="public[]" id="public_2" type="checkbox" aria-describedby="public_hint" value="2"/> Option 2</label><input type="hidden" value="" name="public[]"/><span class="help-block" id="public_hint">Some helpful words</span></div>)
      end

      it 'with error' do
        element = builder.inline_checkbox(
          :public,
          collection: collection_array,
          error: 'Something nasty happened'
        )
        element.to_s.must_equal %(<div class="form-group has-error"><label class="checkbox-inline"><input name="public[]" id="public_1" type="checkbox" value="1"/> Option 1</label><label class="checkbox-inline"><input name="public[]" id="public_2" type="checkbox" value="2"/> Option 2</label><input type="hidden" value="" name="public[]"/><span class="help-block">Something nasty happened</span></div>)
      end

      it 'all together!' do
        element = builder.inline_checkbox(
          :public,
          label: 'Public',
          collection: collection_array,
          hint: 'Some helpful words',
          error: 'Something nasty happened'
        )
        element.to_s.must_equal %(<div class="form-group has-error"><label class="control-label">Public</label><div><label class="checkbox-inline"><input name="public[]" id="public_1" type="checkbox" aria-describedby="public_hint" value="1"/> Option 1</label><label class="checkbox-inline"><input name="public[]" id="public_2" type="checkbox" aria-describedby="public_hint" value="2"/> Option 2</label></div><input type="hidden" value="" name="public[]"/><span class="help-block" id="public_hint">Some helpful words</span><span class="help-block">Something nasty happened</span></div>)
      end
    end
  end

  describe Formular::Elements::Bootstrap3::InlineRadio do
    it 'with value and label' do
      element = builder.inline_radio(:public, value: true, label: 'Public')
      element.to_s.must_equal %(<div class="form-group"><label class="radio-inline"><input name="public" id="public" type="radio" value="true"/> Public</label></div>)
    end

    it 'with hint' do
      element = builder.inline_radio(
        :public,
        value: 1,
        label: 'Public',
        hint: 'Some helpful words'
      )
      element.to_s.must_equal %(<div class="form-group"><label class="radio-inline"><input name="public" id="public" type="radio" aria-describedby="public_hint" value="1"/> Public</label><span class="help-block" id="public_hint">Some helpful words</span></div>)
    end

    it 'with error' do
      element = builder.inline_radio(
        :public,
        value: 1,
        label: 'Public',
        error: 'Something nasty happened'
      )
      element.to_s.must_equal %(<div class="form-group has-error"><label class="radio-inline"><input name="public" id="public" type="radio" value="1"/> Public</label><span class="help-block">Something nasty happened</span></div>)
    end

    it 'all together!' do
      element = builder.inline_radio(
        :public,
        value: 1,
        label: 'Public',
        error: 'Something nasty happened',
        hint: 'Some helpful words'
      )
      element.to_s.must_equal %(<div class="form-group has-error"><label class="radio-inline"><input name="public" id="public" type="radio" aria-describedby="public_hint" value="1"/> Public</label><span class="help-block" id="public_hint">Some helpful words</span><span class="help-block">Something nasty happened</span></div>)
    end

    describe 'with collection' do
      it 'no group label' do
        element = builder.inline_radio(:public, collection: collection_array)
        element.to_s.must_equal %(<div class="form-group"><label class="radio-inline"><input name="public" id="public_1" type="radio" value="1"/> Option 1</label><label class="radio-inline"><input name="public" id="public_2" type="radio" value="2"/> Option 2</label></div>)
      end

      it 'with group label' do
        element = builder.inline_radio(
          :public,
          label: 'Public',
          collection: collection_array
        )
        element.to_s.must_equal %(<div class="form-group"><label class="control-label">Public</label><div><label class="radio-inline"><input name="public" id="public_1" type="radio" value="1"/> Option 1</label><label class="radio-inline"><input name="public" id="public_2" type="radio" value="2"/> Option 2</label></div></div>)
      end

      it 'with hint' do
        element = builder.inline_radio(
          :public,
          collection: collection_array,
          hint: 'Some helpful words'
        )
        element.to_s.must_equal %(<div class="form-group"><label class="radio-inline"><input name="public" id="public_1" type="radio" aria-describedby="public_hint" value="1"/> Option 1</label><label class="radio-inline"><input name="public" id="public_2" type="radio" aria-describedby="public_hint" value="2"/> Option 2</label><span class="help-block" id="public_hint">Some helpful words</span></div>)
      end

      it 'with error' do
        element = builder.inline_radio(
          :public,
          collection: collection_array,
          error: 'Something nasty happened'
        )
        element.to_s.must_equal %(<div class="form-group has-error"><label class="radio-inline"><input name="public" id="public_1" type="radio" value="1"/> Option 1</label><label class="radio-inline"><input name="public" id="public_2" type="radio" value="2"/> Option 2</label><span class="help-block">Something nasty happened</span></div>)
      end

      it 'all together!' do
        element = builder.inline_radio(
          :public,
          label: 'Public',
          collection: collection_array,
          hint: 'Some helpful words',
          error: 'Something nasty happened'
        )
        element.to_s.must_equal %(<div class="form-group has-error"><label class="control-label">Public</label><div><label class="radio-inline"><input name="public" id="public_1" type="radio" aria-describedby="public_hint" value="1"/> Option 1</label><label class="radio-inline"><input name="public" id="public_2" type="radio" aria-describedby="public_hint" value="2"/> Option 2</label></div><span class="help-block" id="public_hint">Some helpful words</span><span class="help-block">Something nasty happened</span></div>)
      end
    end
  end
end