require 'test_helper'
require 'formular/builders/bootstrap3'
require 'formular/elements/bootstrap3'
require 'formular/elements/bootstrap3/checkable_controls'

describe 'Bootstrap3::CheckableControls' do
  let(:builder) { Formular::Builders::Bootstrap3.new }
  let(:collection_array) { [[1, 'Option 1'], [2, 'Option 2']] }

  describe Formular::Elements::Bootstrap3::Checkbox do
    it 'with value and label' do
      element = builder.checkbox(:public, label: 'Public')
      element.to_s.must_equal %(<div class="form-group"><input value="0" name="public" type="hidden"/><div class="checkbox"><label><input type="checkbox" name="public" value="1" id="public"/> Public</label></div></div>)
    end

    it 'with hint' do
      element = builder.checkbox(
        :public,
        label: 'Public',
        hint: 'Some helpful words'
      )
      element.to_s.must_equal %(<div class="form-group"><input value="0" name="public" type="hidden"/><div class="checkbox"><label><input name="public" id="public" type="checkbox" aria-describedby="public_hint" value="1"/> Public</label></div><span id="public_hint" class="help-block">Some helpful words</span></div>)
    end

    it 'with error' do
      element = builder.checkbox(
        :public,
        label: 'Public',
        error: 'Something nasty happened'
      )
      element.to_s.must_equal %(<div class="form-group has-error"><input value="0" name="public" type="hidden"/><div class="checkbox"><label><input name="public" id="public" type="checkbox" value="1"/> Public</label></div><span class="help-block">Something nasty happened</span></div>)
    end

    it 'all together!' do
      element = builder.checkbox(
        :public,
        label: 'Public',
        error: 'Something nasty happened',
        hint: 'Some helpful words'
      )
      element.to_s.must_equal %(<div class="form-group has-error"><input value="0" name="public" type="hidden"/><div class="checkbox"><label><input type="checkbox" name="public" id="public" aria-describedby="public_hint" value="1"/> Public</label></div><span id="public_hint" class="help-block">Some helpful words</span><span class="help-block">Something nasty happened</span></div>)
    end

    describe 'with collection' do
      it 'no group label' do
        element = builder.checkbox(:public, collection: collection_array)
        element.to_s.must_equal %(<div class="form-group"><div class="checkbox"><label><input type="checkbox" name="public[]" value="1" id="public_1"/> Option 1</label></div><div class="checkbox"><label><input type="checkbox" name="public[]" value="2" id="public_2"/> Option 2</label></div><input value="" name="public[]" type="hidden"/></div>)
      end

      it 'with group label' do
        element = builder.checkbox(
          :public,
          label: 'Public',
          collection: collection_array
        )
        element.to_s.must_equal %(<div class="form-group"><label class="control-label">Public</label><div class="checkbox"><label><input type="checkbox" name="public[]" value="1" id="public_1"/> Option 1</label></div><div class="checkbox"><label><input type="checkbox" name="public[]" value="2" id="public_2"/> Option 2</label></div><input value="" name="public[]" type="hidden"/></div>)
      end

      it 'with hint' do
        element = builder.checkbox(
          :public,
          collection: collection_array,
          hint: 'Some helpful words'
        )
        element.to_s.must_equal %(<div class="form-group"><div class="checkbox"><label><input type="checkbox" aria-describedby="public_hint" name="public[]" value="1" id="public_1"/> Option 1</label></div><div class="checkbox"><label><input type="checkbox" aria-describedby="public_hint" name="public[]" value="2" id="public_2"/> Option 2</label></div><input value="" name="public[]" type="hidden"/><span id="public_hint" class="help-block">Some helpful words</span></div>)
      end

      it 'with error' do
        element = builder.checkbox(
          :public,
          collection: collection_array,
          error: 'Something nasty happened'
        )
        element.to_s.must_equal %(<div class="form-group has-error"><div class="checkbox"><label><input type="checkbox" name="public[]" value="1" id="public_1"/> Option 1</label></div><div class="checkbox"><label><input type="checkbox" name="public[]" value="2" id="public_2"/> Option 2</label></div><input value="" name="public[]" type="hidden"/><span class="help-block">Something nasty happened</span></div>)
      end

      it 'all together!' do
        element = builder.checkbox(
          :public,
          label: 'Public',
          collection: collection_array,
          hint: 'Some helpful words',
          error: 'Something nasty happened'
        )
        element.to_s.must_equal %(<div class="form-group has-error"><label class="control-label">Public</label><div class="checkbox"><label><input type="checkbox" aria-describedby="public_hint" name="public[]" value="1" id="public_1"/> Option 1</label></div><div class="checkbox"><label><input type="checkbox" aria-describedby="public_hint" name="public[]" value="2" id="public_2"/> Option 2</label></div><input value="" name="public[]" type="hidden"/><span id="public_hint" class="help-block">Some helpful words</span><span class="help-block">Something nasty happened</span></div>)
      end
    end
  end

  describe Formular::Elements::Bootstrap3::Radio do
    it 'with value and label' do
      element = builder.radio(:public, label: 'Public', value: 1)
      element.to_s.must_equal %(<div class="form-group"><div class="radio"><label><input value="1" type="radio" name="public" id="public"/> Public</label></div></div>)
    end

    it 'with hint' do
      element = builder.radio(
        :public,
        value: 1,
        label: 'Public',
        hint: 'Some helpful words'
      )
      element.to_s.must_equal %(<div class="form-group"><div class="radio"><label><input value="1" type="radio" name="public" id="public" aria-describedby="public_hint"/> Public</label></div><span id="public_hint" class="help-block">Some helpful words</span></div>)
    end

    it 'with error' do
      element = builder.radio(
        :public,
        value: 1,
        label: 'Public',
        error: 'Something nasty happened'
      )
      element.to_s.must_equal %(<div class="form-group has-error"><div class="radio"><label><input value="1" type="radio" name="public" id="public"/> Public</label></div><span class="help-block">Something nasty happened</span></div>)
    end

    it 'all together!' do
      element = builder.radio(
        :public,
        value: 1,
        label: 'Public',
        error: 'Something nasty happened',
        hint: 'Some helpful words'
      )
      element.to_s.must_equal %(<div class="form-group has-error"><div class="radio"><label><input value="1" type="radio" name="public" id="public" aria-describedby="public_hint"/> Public</label></div><span id="public_hint" class="help-block">Some helpful words</span><span class="help-block">Something nasty happened</span></div>)
    end

    describe 'with collection' do
      it 'no group label' do
        element = builder.radio(:public, collection: collection_array)
        element.to_s.must_equal %(<div class="form-group"><div class="radio"><label><input type="radio" name="public" value="1" id="public_1"/> Option 1</label></div><div class="radio"><label><input type="radio" name="public" value="2" id="public_2"/> Option 2</label></div></div>)
      end

      it 'with group label' do
        element = builder.radio(
          :public,
          label: 'Public',
          collection: collection_array
        )
        element.to_s.must_equal %(<div class="form-group"><label class="control-label">Public</label><div class="radio"><label><input type="radio" name="public" value="1" id="public_1"/> Option 1</label></div><div class="radio"><label><input type="radio" name="public" value="2" id="public_2"/> Option 2</label></div></div>)
      end

      it 'with hint' do
        element = builder.radio(
          :public,
          collection: collection_array,
          hint: 'Some helpful words'
        )
        element.to_s.must_equal %(<div class="form-group"><div class="radio"><label><input type="radio" aria-describedby="public_hint" name="public" value="1" id="public_1"/> Option 1</label></div><div class="radio"><label><input type="radio" aria-describedby="public_hint" name="public" value="2" id="public_2"/> Option 2</label></div><span id="public_hint" class="help-block">Some helpful words</span></div>)
      end

      it 'with error' do
        element = builder.radio(
          :public,
          collection: collection_array,
          error: 'Something nasty happened'
        )
        element.to_s.must_equal %(<div class="form-group has-error"><div class="radio"><label><input type="radio" name="public" value="1" id="public_1"/> Option 1</label></div><div class="radio"><label><input type="radio" name="public" value="2" id="public_2"/> Option 2</label></div><span class="help-block">Something nasty happened</span></div>)
      end

      it 'all together!' do
        element = builder.radio(
          :public,
          label: 'Public',
          collection: collection_array,
          hint: 'Some helpful words',
          error: 'Something nasty happened'
        )
        element.to_s.must_equal %(<div class="form-group has-error"><label class="control-label">Public</label><div class="radio"><label><input type="radio" aria-describedby="public_hint" name="public" value="1" id="public_1"/> Option 1</label></div><div class="radio"><label><input type="radio" aria-describedby="public_hint" name="public" value="2" id="public_2"/> Option 2</label></div><span id="public_hint" class="help-block">Some helpful words</span><span class="help-block">Something nasty happened</span></div>)
      end
    end
  end

  describe Formular::Elements::Bootstrap3::InlineCheckbox do
    it 'with value and label' do
      element = builder.inline_checkbox(:public, label: 'Public')
      element.to_s.must_equal %(<div class="form-group"><input value="0" name="public" type="hidden"/><label class="checkbox-inline"><input name="public" id="public" type="checkbox" value="1"/> Public</label></div>)
    end

    it 'with hint' do
      element = builder.inline_checkbox(
        :public,
        label: 'Public',
        hint: 'Some helpful words'
      )
      element.to_s.must_equal %(<div class="form-group"><input value="0" name="public" type="hidden"/><label class="checkbox-inline"><input name="public" id="public" type="checkbox" aria-describedby="public_hint" value="1"/> Public</label><span id="public_hint" class="help-block">Some helpful words</span></div>)
    end

    it 'with error' do
      element = builder.inline_checkbox(
        :public,
        label: 'Public',
        error: 'Something nasty happened'
      )
      element.to_s.must_equal %(<div class="form-group has-error"><input value="0" name="public" type="hidden"/><label class="checkbox-inline"><input name="public" id="public" type="checkbox" value="1"/> Public</label><span class="help-block">Something nasty happened</span></div>)
    end

    it 'all together!' do
      element = builder.inline_checkbox(
        :public,
        label: 'Public',
        error: 'Something nasty happened',
        hint: 'Some helpful words'
      )
      element.to_s.must_equal %(<div class="form-group has-error"><input value="0" name="public" type="hidden"/><label class="checkbox-inline"><input name="public" id="public" type="checkbox" aria-describedby="public_hint" value="1"/> Public</label><span id="public_hint" class="help-block">Some helpful words</span><span class="help-block">Something nasty happened</span></div>)
    end

    describe 'with collection' do
      it 'no group label' do
        element = builder.inline_checkbox(:public, collection: collection_array)
        element.to_s.must_equal %(<div class="form-group"><label class="checkbox-inline"><input type="checkbox" name="public[]" value="1" id="public_1"/> Option 1</label><label class="checkbox-inline"><input type="checkbox" name="public[]" value="2" id="public_2"/> Option 2</label><input value="" name="public[]" type="hidden"/></div>)
      end

      it 'with group label' do
        element = builder.inline_checkbox(
          :public,
          label: 'Public',
          collection: collection_array
        )
        element.to_s.must_equal %(<div class="form-group"><label class="control-label">Public</label><div><label class="checkbox-inline"><input type="checkbox" name="public[]" value="1" id="public_1"/> Option 1</label><label class="checkbox-inline"><input type="checkbox" name="public[]" value="2" id="public_2"/> Option 2</label></div><input value="" name="public[]" type="hidden"/></div>)
      end

      it 'with hint' do
        element = builder.inline_checkbox(
          :public,
          collection: collection_array,
          hint: 'Some helpful words'
        )
        element.to_s.must_equal %(<div class="form-group"><label class="checkbox-inline"><input type="checkbox" aria-describedby="public_hint" name="public[]" value="1" id="public_1"/> Option 1</label><label class="checkbox-inline"><input type="checkbox" aria-describedby="public_hint" name="public[]" value="2" id="public_2"/> Option 2</label><input value="" name="public[]" type="hidden"/><span id="public_hint" class="help-block">Some helpful words</span></div>)
      end

      it 'with error' do
        element = builder.inline_checkbox(
          :public,
          collection: collection_array,
          error: 'Something nasty happened'
        )
        element.to_s.must_equal %(<div class="form-group has-error"><label class="checkbox-inline"><input type="checkbox" name="public[]" value="1" id="public_1"/> Option 1</label><label class="checkbox-inline"><input type="checkbox" name="public[]" value="2" id="public_2"/> Option 2</label><input value="" name="public[]" type="hidden"/><span class="help-block">Something nasty happened</span></div>)
      end

      it 'all together!' do
        element = builder.inline_checkbox(
          :public,
          label: 'Public',
          collection: collection_array,
          hint: 'Some helpful words',
          error: 'Something nasty happened'
        )
        element.to_s.must_equal %(<div class="form-group has-error"><label class="control-label">Public</label><div><label class="checkbox-inline"><input type="checkbox" aria-describedby="public_hint" name="public[]" value="1" id="public_1"/> Option 1</label><label class="checkbox-inline"><input type="checkbox" aria-describedby="public_hint" name="public[]" value="2" id="public_2"/> Option 2</label></div><input value="" name="public[]" type="hidden"/><span id="public_hint" class="help-block">Some helpful words</span><span class="help-block">Something nasty happened</span></div>)
      end
    end
  end

  describe Formular::Elements::Bootstrap3::InlineRadio do
    it 'with value and label' do
      element = builder.inline_radio(:public, label: 'Public', value: 1)
      element.to_s.must_equal %(<div class="form-group"><label class="radio-inline"><input value="1" type="radio" name="public" id="public"/> Public</label></div>)
    end

    it 'with hint' do
      element = builder.inline_radio(
        :public,
        label: 'Public',
        value: 1,
        hint: 'Some helpful words'
      )
      element.to_s.must_equal %(<div class="form-group"><label class="radio-inline"><input value="1" type="radio" name="public" id="public" aria-describedby="public_hint"/> Public</label><span id="public_hint" class="help-block">Some helpful words</span></div>)
    end

    it 'with error' do
      element = builder.inline_radio(
        :public,
        label: 'Public',
        value: 1,
        error: 'Something nasty happened'
      )
      element.to_s.must_equal %(<div class="form-group has-error"><label class="radio-inline"><input value="1" type="radio" name="public" id="public"/> Public</label><span class="help-block">Something nasty happened</span></div>)
    end

    it 'all together!' do
      element = builder.inline_radio(
        :public,
        label: 'Public',
        value: 1,
        error: 'Something nasty happened',
        hint: 'Some helpful words'
      )
      element.to_s.must_equal %(<div class="form-group has-error"><label class="radio-inline"><input value="1" type="radio" name="public" id="public" aria-describedby="public_hint"/> Public</label><span id="public_hint" class="help-block">Some helpful words</span><span class="help-block">Something nasty happened</span></div>)
    end

    describe 'with collection' do
      it 'no group label' do
        element = builder.inline_radio(:public, collection: collection_array)
        element.to_s.must_equal %(<div class="form-group"><label class="radio-inline"><input type="radio" name="public" value="1" id="public_1"/> Option 1</label><label class="radio-inline"><input type="radio" name="public" value="2" id="public_2"/> Option 2</label></div>)
      end

      it 'with group label' do
        element = builder.inline_radio(
          :public,
          label: 'Public',
          collection: collection_array
        )
        element.to_s.must_equal %(<div class="form-group"><label class="control-label">Public</label><div><label class="radio-inline"><input type="radio" name="public" value="1" id="public_1"/> Option 1</label><label class="radio-inline"><input type="radio" name="public" value="2" id="public_2"/> Option 2</label></div></div>)
      end

      it 'with hint' do
        element = builder.inline_radio(
          :public,
          collection: collection_array,
          hint: 'Some helpful words'
        )
        element.to_s.must_equal %(<div class="form-group"><label class="radio-inline"><input type="radio" aria-describedby="public_hint" name="public" value="1" id="public_1"/> Option 1</label><label class="radio-inline"><input type="radio" aria-describedby="public_hint" name="public" value="2" id="public_2"/> Option 2</label><span id="public_hint" class="help-block">Some helpful words</span></div>)
      end

      it 'with error' do
        element = builder.inline_radio(
          :public,
          collection: collection_array,
          error: 'Something nasty happened'
        )
        element.to_s.must_equal %(<div class="form-group has-error"><label class="radio-inline"><input type="radio" name="public" value="1" id="public_1"/> Option 1</label><label class="radio-inline"><input type="radio" name="public" value="2" id="public_2"/> Option 2</label><span class="help-block">Something nasty happened</span></div>)
      end

      it 'all together!' do
        element = builder.inline_radio(
          :public,
          label: 'Public',
          collection: collection_array,
          hint: 'Some helpful words',
          error: 'Something nasty happened'
        )
        element.to_s.must_equal %(<div class="form-group has-error"><label class="control-label">Public</label><div><label class="radio-inline"><input type="radio" aria-describedby="public_hint" name="public" value="1" id="public_1"/> Option 1</label><label class="radio-inline"><input type="radio" aria-describedby="public_hint" name="public" value="2" id="public_2"/> Option 2</label></div><span id="public_hint" class="help-block">Some helpful words</span><span class="help-block">Something nasty happened</span></div>)
      end
    end
  end
end