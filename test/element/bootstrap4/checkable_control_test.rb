require 'test_helper'
require 'formular/builders/bootstrap4'
require 'formular/element/bootstrap4'
require 'formular/element/bootstrap4/checkable_control'

describe 'Bootstrap4::CheckableControl' do
  let(:builder) { Formular::Builders::Bootstrap4.new }
  let(:collection_array) { COLLECTION_ARRAY }

  describe Formular::Element::Bootstrap4::Checkbox do
    it 'with value and label' do
      element = builder.checkbox(:public, label: 'Public')
      element.to_s.must_equal %(<fieldset class="form-group"><input value="0" name="public" type="hidden"/><div class="form-check"><label class="form-check-label"><input name="public" id="public" type="checkbox" value="1" class="form-check-input"/> Public</label></div></fieldset>)
    end

    it 'with hint' do
      element = builder.checkbox(
        :public,
        label: 'Public',
        hint: 'Some helpful words'
      )
      element.to_s.must_equal %(<fieldset class="form-group"><input value="0" name="public" type="hidden"/><div class="form-check"><label class="form-check-label"><input name="public" id="public" type="checkbox" value="1" aria-describedby="public_hint" class="form-check-input"/> Public</label></div><small id="public_hint" class="form-text text-muted">Some helpful words</small></fieldset>)
    end

    it 'with error' do
      element = builder.checkbox(
        :public,
        label: 'Public',
        error: 'Something nasty happened'
      )
      element.to_s.must_equal %(<fieldset class="form-group has-danger"><input value="0" name="public" type="hidden"/><div class="form-check"><label class="form-check-label"><input name="public" id="public" type="checkbox" value="1" class="form-check-input"/> Public</label></div><div class="form-control-feedback">Something nasty happened</div></fieldset>)
    end

    it 'all together!' do
      element = builder.checkbox(
        :public,
        label: 'Public',
        error: 'Something nasty happened',
        hint: 'Some helpful words'
      )
      element.to_s.must_equal %(<fieldset class="form-group has-danger"><input value="0" name="public" type="hidden"/><div class="form-check"><label class="form-check-label"><input name="public" id="public" type="checkbox" value="1" aria-describedby="public_hint" class="form-check-input"/> Public</label></div><small id="public_hint" class="form-text text-muted">Some helpful words</small><div class="form-control-feedback">Something nasty happened</div></fieldset>)
    end

    describe 'with collection' do
      it 'no group label' do
        element = builder.checkbox(:public, collection: collection_array)
        element.to_s.must_equal %(<fieldset class="form-group"><div class="form-check"><label class="form-check-label"><input type="checkbox" value="1" name="public[]" id="public_1" class="form-check-input"/> Option 1</label></div><div class="form-check"><label class="form-check-label"><input type="checkbox" value="2" name="public[]" id="public_2" class="form-check-input"/> Option 2</label></div><input value="" name="public[]" type="hidden"/></fieldset>)
      end

      it 'with group label' do
        element = builder.checkbox(
          :public,
          label: 'Public',
          collection: collection_array
        )
        element.to_s.must_equal %(<fieldset class="form-group"><legend class="form-control-label">Public</legend><div class="form-check"><label class="form-check-label"><input type="checkbox" value="1" name="public[]" id="public_1" class="form-check-input"/> Option 1</label></div><div class="form-check"><label class="form-check-label"><input type="checkbox" value="2" name="public[]" id="public_2" class="form-check-input"/> Option 2</label></div><input value="" name="public[]" type="hidden"/></fieldset>)
      end

      it 'with hint' do
        element = builder.checkbox(
          :public,
          collection: collection_array,
          hint: 'Some helpful words'
        )
        element.to_s.must_equal %(<fieldset class="form-group"><div class="form-check"><label class="form-check-label"><input type="checkbox" value="1" aria-describedby="public_hint" name="public[]" id="public_1" class="form-check-input"/> Option 1</label></div><div class="form-check"><label class="form-check-label"><input type="checkbox" value="2" aria-describedby="public_hint" name="public[]" id="public_2" class="form-check-input"/> Option 2</label></div><input value="" name="public[]" type="hidden"/><small id="public_hint" class="form-text text-muted">Some helpful words</small></fieldset>)
      end

      it 'with error' do
        element = builder.checkbox(
          :public,
          collection: collection_array,
          error: 'Something nasty happened'
        )
        element.to_s.must_equal %(<fieldset class="form-group has-danger"><div class="form-check"><label class="form-check-label"><input type="checkbox" value="1" name="public[]" id="public_1" class="form-check-input"/> Option 1</label></div><div class="form-check"><label class="form-check-label"><input type="checkbox" value="2" name="public[]" id="public_2" class="form-check-input"/> Option 2</label></div><input value="" name="public[]" type="hidden"/><div class="form-control-feedback">Something nasty happened</div></fieldset>)
      end

      it 'all together!' do
        element = builder.checkbox(
          :public,
          label: 'Public',
          collection: collection_array,
          hint: 'Some helpful words',
          error: 'Something nasty happened'
        )
        element.to_s.must_equal %(<fieldset class="form-group has-danger"><legend class="form-control-label">Public</legend><div class="form-check"><label class="form-check-label"><input type="checkbox" value="1" aria-describedby="public_hint" name="public[]" id="public_1" class="form-check-input"/> Option 1</label></div><div class="form-check"><label class="form-check-label"><input type="checkbox" value="2" aria-describedby="public_hint" name="public[]" id="public_2" class="form-check-input"/> Option 2</label></div><input value="" name="public[]" type="hidden"/><small id="public_hint" class="form-text text-muted">Some helpful words</small><div class="form-control-feedback">Something nasty happened</div></fieldset>)
      end
    end
  end

  describe Formular::Element::Bootstrap4::Radio do
    it 'with value and label' do
      element = builder.radio(:public, label: 'Public', value: 1)
      element.to_s.must_equal %(<fieldset class="form-group"><div class="form-check"><label class="form-check-label"><input value="1" name="public" id="public" type="radio" class="form-check-input"/> Public</label></div></fieldset>)
    end

    it 'with hint' do
      element = builder.radio(
        :public,
        value: 1,
        label: 'Public',
        hint: 'Some helpful words'
      )
      element.to_s.must_equal %(<fieldset class="form-group"><div class="form-check"><label class="form-check-label"><input value="1" name="public" id="public" type="radio" aria-describedby="public_hint" class="form-check-input"/> Public</label></div><small id="public_hint" class="form-text text-muted">Some helpful words</small></fieldset>)
    end

    it 'with error' do
      element = builder.radio(
        :public,
        value: 1,
        label: 'Public',
        error: 'Something nasty happened'
      )
      element.to_s.must_equal %(<fieldset class="form-group has-danger"><div class="form-check"><label class="form-check-label"><input value="1" name="public" id="public" type="radio" class="form-check-input"/> Public</label></div><div class="form-control-feedback">Something nasty happened</div></fieldset>)
    end

    it 'all together!' do
      element = builder.radio(
        :public,
        value: 1,
        label: 'Public',
        error: 'Something nasty happened',
        hint: 'Some helpful words'
      )
      element.to_s.must_equal %(<fieldset class="form-group has-danger"><div class="form-check"><label class="form-check-label"><input value="1" name="public" id="public" type="radio" aria-describedby="public_hint" class="form-check-input"/> Public</label></div><small id="public_hint" class="form-text text-muted">Some helpful words</small><div class="form-control-feedback">Something nasty happened</div></fieldset>)
    end

    describe 'with collection' do
      it 'no group label' do
        element = builder.radio(:public, collection: collection_array)
        element.to_s.must_equal %(<fieldset class="form-group"><div class="form-check"><label class="form-check-label"><input type="radio" name="public" value="1" id="public_1" class="form-check-input"/> Option 1</label></div><div class="form-check"><label class="form-check-label"><input type="radio" name="public" value="2" id="public_2" class="form-check-input"/> Option 2</label></div></fieldset>)
      end

      it 'with group label' do
        element = builder.radio(
          :public,
          label: 'Public',
          collection: collection_array
        )
        element.to_s.must_equal %(<fieldset class="form-group"><legend class="form-control-label">Public</legend><div class="form-check"><label class="form-check-label"><input type="radio" name="public" value="1" id="public_1" class="form-check-input"/> Option 1</label></div><div class="form-check"><label class="form-check-label"><input type="radio" name="public" value="2" id="public_2" class="form-check-input"/> Option 2</label></div></fieldset>)
      end

      it 'with hint' do
        element = builder.radio(
          :public,
          collection: collection_array,
          hint: 'Some helpful words'
        )
        element.to_s.must_equal %(<fieldset class="form-group"><div class="form-check"><label class="form-check-label"><input type="radio" aria-describedby="public_hint" name="public" value="1" id="public_1" class="form-check-input"/> Option 1</label></div><div class="form-check"><label class="form-check-label"><input type="radio" aria-describedby="public_hint" name="public" value="2" id="public_2" class="form-check-input"/> Option 2</label></div><small id="public_hint" class="form-text text-muted">Some helpful words</small></fieldset>)
      end

      it 'with error' do
        element = builder.radio(
          :public,
          collection: collection_array,
          error: 'Something nasty happened'
        )
        element.to_s.must_equal %(<fieldset class="form-group has-danger"><div class="form-check"><label class="form-check-label"><input type="radio" name="public" value="1" id="public_1" class="form-check-input"/> Option 1</label></div><div class="form-check"><label class="form-check-label"><input type="radio" name="public" value="2" id="public_2" class="form-check-input"/> Option 2</label></div><div class="form-control-feedback">Something nasty happened</div></fieldset>)
      end

      it 'all together!' do
        element = builder.radio(
          :public,
          label: 'Public',
          collection: collection_array,
          hint: 'Some helpful words',
          error: 'Something nasty happened'
        )
        element.to_s.must_equal %(<fieldset class="form-group has-danger"><legend class="form-control-label">Public</legend><div class="form-check"><label class="form-check-label"><input type="radio" aria-describedby="public_hint" name="public" value="1" id="public_1" class="form-check-input"/> Option 1</label></div><div class="form-check"><label class="form-check-label"><input type="radio" aria-describedby="public_hint" name="public" value="2" id="public_2" class="form-check-input"/> Option 2</label></div><small id="public_hint" class="form-text text-muted">Some helpful words</small><div class="form-control-feedback">Something nasty happened</div></fieldset>)
      end
    end
  end

  describe Formular::Element::Bootstrap4::InlineCheckbox do
    it 'with value and label' do
      element = builder.inline_checkbox(:public, label: 'Public')
      element.to_s.must_equal %(<fieldset class="form-group"><input value="0" name="public" type="hidden"/><label class="form-check-inline"><input name="public" id="public" type="checkbox" value="1" class="form-check-input"/> Public</label></fieldset>)
    end

    it 'with hint' do
      element = builder.inline_checkbox(
        :public,
        label: 'Public',
        hint: 'Some helpful words'
      )
      element.to_s.must_equal %(<fieldset class="form-group"><input value="0" name="public" type="hidden"/><label class="form-check-inline"><input name="public" id="public" type="checkbox" value="1" aria-describedby="public_hint" class="form-check-input"/> Public</label><small id="public_hint" class="form-text text-muted">Some helpful words</small></fieldset>)
    end

    it 'with error' do
      element = builder.inline_checkbox(
        :public,
        label: 'Public',
        error: 'Something nasty happened'
      )
      element.to_s.must_equal %(<fieldset class="form-group has-danger"><input value="0" name="public" type="hidden"/><label class="form-check-inline"><input name="public" id="public" type="checkbox" value="1" class="form-check-input"/> Public</label><div class="form-control-feedback">Something nasty happened</div></fieldset>)
    end

    it 'all together!' do
      element = builder.inline_checkbox(
        :public,
        label: 'Public',
        error: 'Something nasty happened',
        hint: 'Some helpful words'
      )
      element.to_s.must_equal %(<fieldset class="form-group has-danger"><input value="0" name="public" type="hidden"/><label class="form-check-inline"><input name="public" id="public" type="checkbox" value="1" aria-describedby="public_hint" class="form-check-input"/> Public</label><small id="public_hint" class="form-text text-muted">Some helpful words</small><div class="form-control-feedback">Something nasty happened</div></fieldset>)
    end

    describe 'with collection' do
      it 'no group label' do
        element = builder.inline_checkbox(:public, collection: collection_array)
        element.to_s.must_equal %(<fieldset class="form-group"><label class="form-check-inline"><input type="checkbox" value="1" name="public[]" id="public_1" class="form-check-input"/> Option 1</label><label class="form-check-inline"><input type="checkbox" value="2" name="public[]" id="public_2" class="form-check-input"/> Option 2</label><input value="" name="public[]" type="hidden"/></fieldset>)
      end

      it 'with group label' do
        element = builder.inline_checkbox(
          :public,
          label: 'Public',
          collection: collection_array
        )
        element.to_s.must_equal %(<fieldset class="form-group"><legend class="form-control-label">Public</legend><div><label class="form-check-inline"><input type="checkbox" value="1" name="public[]" id="public_1" class="form-check-input"/> Option 1</label><label class="form-check-inline"><input type="checkbox" value="2" name="public[]" id="public_2" class="form-check-input"/> Option 2</label></div><input value="" name="public[]" type="hidden"/></fieldset>)
      end

      it 'with hint' do
        element = builder.inline_checkbox(
          :public,
          collection: collection_array,
          hint: 'Some helpful words'
        )
        element.to_s.must_equal %(<fieldset class="form-group"><label class="form-check-inline"><input type="checkbox" value="1" aria-describedby="public_hint" name="public[]" id="public_1" class="form-check-input"/> Option 1</label><label class="form-check-inline"><input type="checkbox" value="2" aria-describedby="public_hint" name="public[]" id="public_2" class="form-check-input"/> Option 2</label><input value="" name="public[]" type="hidden"/><small id="public_hint" class="form-text text-muted">Some helpful words</small></fieldset>)
      end

      it 'with error' do
        element = builder.inline_checkbox(
          :public,
          collection: collection_array,
          error: 'Something nasty happened'
        )
        element.to_s.must_equal %(<fieldset class="form-group has-danger"><label class="form-check-inline"><input type="checkbox" value="1" name="public[]" id="public_1" class="form-check-input"/> Option 1</label><label class="form-check-inline"><input type="checkbox" value="2" name="public[]" id="public_2" class="form-check-input"/> Option 2</label><input value="" name="public[]" type="hidden"/><div class="form-control-feedback">Something nasty happened</div></fieldset>)
      end

      it 'all together!' do
        element = builder.inline_checkbox(
          :public,
          label: 'Public',
          collection: collection_array,
          hint: 'Some helpful words',
          error: 'Something nasty happened'
        )
        element.to_s.must_equal %(<fieldset class="form-group has-danger"><legend class="form-control-label">Public</legend><div><label class="form-check-inline"><input type="checkbox" value="1" aria-describedby="public_hint" name="public[]" id="public_1" class="form-check-input"/> Option 1</label><label class="form-check-inline"><input type="checkbox" value="2" aria-describedby="public_hint" name="public[]" id="public_2" class="form-check-input"/> Option 2</label></div><input value="" name="public[]" type="hidden"/><small id="public_hint" class="form-text text-muted">Some helpful words</small><div class="form-control-feedback">Something nasty happened</div></fieldset>)
      end
    end
  end

  describe Formular::Element::Bootstrap4::InlineRadio do
    it 'with value and label' do
      element = builder.inline_radio(:public, label: 'Public', value: 1)
      element.to_s.must_equal %(<fieldset class="form-group"><label class="form-check-inline"><input value="1" name="public" id="public" type="radio" class="form-check-input"/> Public</label></fieldset>)
    end

    it 'with hint' do
      element = builder.inline_radio(
        :public,
        label: 'Public',
        value: 1,
        hint: 'Some helpful words'
      )
      element.to_s.must_equal %(<fieldset class="form-group"><label class="form-check-inline"><input value="1" name="public" id="public" type="radio" aria-describedby="public_hint" class="form-check-input"/> Public</label><small id="public_hint" class="form-text text-muted">Some helpful words</small></fieldset>)
    end

    it 'with error' do
      element = builder.inline_radio(
        :public,
        label: 'Public',
        value: 1,
        error: 'Something nasty happened'
      )
      element.to_s.must_equal %(<fieldset class="form-group has-danger"><label class="form-check-inline"><input value="1" name="public" id="public" type="radio" class="form-check-input"/> Public</label><div class="form-control-feedback">Something nasty happened</div></fieldset>)
    end

    it 'all together!' do
      element = builder.inline_radio(
        :public,
        label: 'Public',
        value: 1,
        error: 'Something nasty happened',
        hint: 'Some helpful words'
      )
      element.to_s.must_equal %(<fieldset class="form-group has-danger"><label class="form-check-inline"><input value="1" name="public" id="public" type="radio" aria-describedby="public_hint" class="form-check-input"/> Public</label><small id="public_hint" class="form-text text-muted">Some helpful words</small><div class="form-control-feedback">Something nasty happened</div></fieldset>)
    end

    describe 'with collection' do
      it 'no group label' do
        element = builder.inline_radio(:public, collection: collection_array)
        element.to_s.must_equal %(<fieldset class="form-group"><label class="form-check-inline"><input type="radio" name="public" value="1" id="public_1" class="form-check-input"/> Option 1</label><label class="form-check-inline"><input type="radio" name="public" value="2" id="public_2" class="form-check-input"/> Option 2</label></fieldset>)
      end

      it 'with group label' do
        element = builder.inline_radio(
          :public,
          label: 'Public',
          collection: collection_array
        )
        element.to_s.must_equal %(<fieldset class="form-group"><legend class="form-control-label">Public</legend><div><label class="form-check-inline"><input type="radio" name="public" value="1" id="public_1" class="form-check-input"/> Option 1</label><label class="form-check-inline"><input type="radio" name="public" value="2" id="public_2" class="form-check-input"/> Option 2</label></div></fieldset>)
      end

      it 'with hint' do
        element = builder.inline_radio(
          :public,
          collection: collection_array,
          hint: 'Some helpful words'
        )
        element.to_s.must_equal %(<fieldset class="form-group"><label class="form-check-inline"><input type="radio" aria-describedby="public_hint" name="public" value="1" id="public_1" class="form-check-input"/> Option 1</label><label class="form-check-inline"><input type="radio" aria-describedby="public_hint" name="public" value="2" id="public_2" class="form-check-input"/> Option 2</label><small id="public_hint" class="form-text text-muted">Some helpful words</small></fieldset>)
      end

      it 'with error' do
        element = builder.inline_radio(
          :public,
          collection: collection_array,
          error: 'Something nasty happened'
        )
        element.to_s.must_equal %(<fieldset class="form-group has-danger"><label class="form-check-inline"><input type="radio" name="public" value="1" id="public_1" class="form-check-input"/> Option 1</label><label class="form-check-inline"><input type="radio" name="public" value="2" id="public_2" class="form-check-input"/> Option 2</label><div class="form-control-feedback">Something nasty happened</div></fieldset>)
      end

      it 'all together!' do
        element = builder.inline_radio(
          :public,
          label: 'Public',
          collection: collection_array,
          hint: 'Some helpful words',
          error: 'Something nasty happened'
        )
        element.to_s.must_equal %(<fieldset class="form-group has-danger"><legend class="form-control-label">Public</legend><div><label class="form-check-inline"><input type="radio" aria-describedby="public_hint" name="public" value="1" id="public_1" class="form-check-input"/> Option 1</label><label class="form-check-inline"><input type="radio" aria-describedby="public_hint" name="public" value="2" id="public_2" class="form-check-input"/> Option 2</label></div><small id="public_hint" class="form-text text-muted">Some helpful words</small><div class="form-control-feedback">Something nasty happened</div></fieldset>)
      end
    end
  end
end