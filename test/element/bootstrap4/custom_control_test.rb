require 'test_helper'
require 'formular/builders/bootstrap4'
require 'formular/element/bootstrap4'
require 'formular/element/bootstrap4/custom_control'

describe 'Bootstrap4::CustomControl' do
  let(:builder) { Formular::Builders::Bootstrap4.new }
  let(:collection_array) { COLLECTION_ARRAY }

  describe Formular::Element::Bootstrap4::Inline::CustomCheckbox do
    it 'with value and label' do
      element = builder.custom_checkbox(:public, label: 'Public')
      element.to_s.must_equal %(<fieldset class="form-group"><input value="0" name="public" type="hidden"/><label class="custom-control custom-checkbox"><input name="public" id="public" type="checkbox" value="1" class="custom-control-input"/><span class=\"custom-control-indicator\"></span><span class=\"custom-control-description\">Public</span></label></fieldset>)
    end

    it 'with hint' do
      element = builder.custom_checkbox(
        :public,
        label: 'Public',
        hint: 'Some helpful words'
      )
      element.to_s.must_equal %(<fieldset class="form-group"><input value="0" name="public" type="hidden"/><label class="custom-control custom-checkbox"><input name="public" id="public" type="checkbox" value="1" aria-describedby="public_hint" class="custom-control-input"/><span class=\"custom-control-indicator\"></span><span class=\"custom-control-description\">Public</span></label><small id="public_hint" class="form-text text-muted">Some helpful words</small></fieldset>)
    end

    it 'with error' do
      element = builder.custom_checkbox(
        :public,
        label: 'Public',
        error: 'Something nasty happened'
      )
      element.to_s.must_equal %(<fieldset class="form-group has-danger"><input value="0" name="public" type="hidden"/><label class="custom-control custom-checkbox"><input name="public" id="public" type="checkbox" value="1" class="custom-control-input"/><span class=\"custom-control-indicator\"></span><span class=\"custom-control-description\">Public</span></label><div class="form-control-feedback">Something nasty happened</div></fieldset>)
    end

    it 'all together!' do
      element = builder.custom_checkbox(
        :public,
        label: 'Public',
        error: 'Something nasty happened',
        hint: 'Some helpful words'
      )
      element.to_s.must_equal %(<fieldset class="form-group has-danger"><input value="0" name="public" type="hidden"/><label class="custom-control custom-checkbox"><input name="public" id="public" type="checkbox" value="1" aria-describedby="public_hint" class="custom-control-input"/><span class=\"custom-control-indicator\"></span><span class=\"custom-control-description\">Public</span></label><small id="public_hint" class="form-text text-muted">Some helpful words</small><div class="form-control-feedback">Something nasty happened</div></fieldset>)
    end

    describe 'with collection' do
      it 'no group label' do
        element = builder.custom_checkbox(:public, collection: collection_array)
        element.to_s.must_equal %(<fieldset class="form-group"><label class="custom-control custom-checkbox"><input type="checkbox" value="1" name="public[]" id="public_1" class="custom-control-input"/><span class=\"custom-control-indicator\"></span><span class=\"custom-control-description\">Option 1</span></label><label class="custom-control custom-checkbox"><input type="checkbox" value="2" name="public[]" id="public_2" class="custom-control-input"/><span class=\"custom-control-indicator\"></span><span class=\"custom-control-description\">Option 2</span></label><input value="" name="public[]" type="hidden"/></fieldset>)
      end

      it 'with group label' do
        element = builder.custom_checkbox(
          :public,
          label: 'Public',
          collection: collection_array
        )
        element.to_s.must_equal %(<fieldset class="form-group"><legend class="form-control-label">Public</legend><label class="custom-control custom-checkbox"><input type="checkbox" value="1" name="public[]" id="public_1" class="custom-control-input"/><span class=\"custom-control-indicator\"></span><span class=\"custom-control-description\">Option 1</span></label><label class="custom-control custom-checkbox"><input type="checkbox" value="2" name="public[]" id="public_2" class="custom-control-input"/><span class=\"custom-control-indicator\"></span><span class=\"custom-control-description\">Option 2</span></label><input value="" name="public[]" type="hidden"/></fieldset>)
      end

      it 'with hint' do
        element = builder.custom_checkbox(
          :public,
          collection: collection_array,
          hint: 'Some helpful words'
        )
        element.to_s.must_equal %(<fieldset class="form-group"><label class="custom-control custom-checkbox"><input type="checkbox" value="1" aria-describedby="public_hint" name="public[]" id="public_1" class="custom-control-input"/><span class=\"custom-control-indicator\"></span><span class=\"custom-control-description\">Option 1</span></label><label class="custom-control custom-checkbox"><input type="checkbox" value="2" aria-describedby="public_hint" name="public[]" id="public_2" class="custom-control-input"/><span class=\"custom-control-indicator\"></span><span class=\"custom-control-description\">Option 2</span></label><input value="" name="public[]" type="hidden"/><small id="public_hint" class="form-text text-muted">Some helpful words</small></fieldset>)
      end

      it 'with error' do
        element = builder.custom_checkbox(
          :public,
          collection: collection_array,
          error: 'Something nasty happened'
        )
        element.to_s.must_equal %(<fieldset class="form-group has-danger"><label class="custom-control custom-checkbox"><input type="checkbox" value="1" name="public[]" id="public_1" class="custom-control-input"/><span class=\"custom-control-indicator\"></span><span class=\"custom-control-description\">Option 1</span></label><label class="custom-control custom-checkbox"><input type="checkbox" value="2" name="public[]" id="public_2" class="custom-control-input"/><span class=\"custom-control-indicator\"></span><span class=\"custom-control-description\">Option 2</span></label><input value="" name="public[]" type="hidden"/><div class="form-control-feedback">Something nasty happened</div></fieldset>)
      end

      it 'all together!' do
        element = builder.custom_checkbox(
          :public,
          label: 'Public',
          collection: collection_array,
          hint: 'Some helpful words',
          error: 'Something nasty happened'
        )
        element.to_s.must_equal %(<fieldset class="form-group has-danger"><legend class="form-control-label">Public</legend><label class="custom-control custom-checkbox"><input type="checkbox" value="1" aria-describedby="public_hint" name="public[]" id="public_1" class="custom-control-input"/><span class=\"custom-control-indicator\"></span><span class=\"custom-control-description\">Option 1</span></label><label class="custom-control custom-checkbox"><input type="checkbox" value="2" aria-describedby="public_hint" name="public[]" id="public_2" class="custom-control-input"/><span class="custom-control-indicator"></span><span class=\"custom-control-description\">Option 2</span></label><input value="" name="public[]" type="hidden"/><small id="public_hint" class="form-text text-muted">Some helpful words</small><div class="form-control-feedback">Something nasty happened</div></fieldset>)
      end
    end
  end

  describe Formular::Element::Bootstrap4::CustomStackedCheckbox do
    it 'with value and label' do
      element = builder.custom_stacked_checkbox(:public, label: 'Public')
      element.to_s.must_equal %(<fieldset class="form-group"><input value="0" name="public" type="hidden"/><div class="custom-controls-stacked"><label class="custom-control custom-checkbox"><input name="public" id="public" type="checkbox" value="1" class="custom-control-input"/><span class=\"custom-control-indicator\"></span><span class=\"custom-control-description\">Public</span></label></div></fieldset>)
    end

    it 'with hint' do
      element = builder.custom_stacked_checkbox(
        :public,
        label: 'Public',
        hint: 'Some helpful words'
      )
      element.to_s.must_equal %(<fieldset class="form-group"><input value="0" name="public" type="hidden"/><div class="custom-controls-stacked"><label class="custom-control custom-checkbox"><input name="public" id="public" type="checkbox" value="1" aria-describedby="public_hint" class="custom-control-input"/><span class=\"custom-control-indicator\"></span><span class=\"custom-control-description\">Public</span></label></div><small id="public_hint" class="form-text text-muted">Some helpful words</small></fieldset>)
    end

    it 'with error' do
      element = builder.custom_stacked_checkbox(
        :public,
        label: 'Public',
        error: 'Something nasty happened'
      )
      element.to_s.must_equal %(<fieldset class="form-group has-danger"><input value="0" name="public" type="hidden"/><div class="custom-controls-stacked"><label class="custom-control custom-checkbox"><input name="public" id="public" type="checkbox" value="1" class="custom-control-input"/><span class=\"custom-control-indicator\"></span><span class=\"custom-control-description\">Public</span></label></div><div class="form-control-feedback">Something nasty happened</div></fieldset>)
    end

    it 'all together!' do
      element = builder.custom_stacked_checkbox(
        :public,
        label: 'Public',
        error: 'Something nasty happened',
        hint: 'Some helpful words'
      )
      element.to_s.must_equal %(<fieldset class="form-group has-danger"><input value="0" name="public" type="hidden"/><div class="custom-controls-stacked"><label class="custom-control custom-checkbox"><input name="public" id="public" type="checkbox" value="1" aria-describedby="public_hint" class="custom-control-input"/><span class=\"custom-control-indicator\"></span><span class=\"custom-control-description\">Public</span></label></div><small id="public_hint" class="form-text text-muted">Some helpful words</small><div class="form-control-feedback">Something nasty happened</div></fieldset>)
    end

    describe 'with collection' do
      it 'no group label' do
        element = builder.custom_stacked_checkbox(:public, collection: collection_array)
        element.to_s.must_equal %(<fieldset class="form-group"><div class="custom-controls-stacked"><label class="custom-control custom-checkbox"><input type="checkbox" value="1" name="public[]" id="public_1" class="custom-control-input"/><span class=\"custom-control-indicator\"></span><span class=\"custom-control-description\">Option 1</span></label><label class="custom-control custom-checkbox"><input type="checkbox" value="2" name="public[]" id="public_2" class="custom-control-input"/><span class=\"custom-control-indicator\"></span><span class=\"custom-control-description\">Option 2</span></label></div><input value="" name="public[]" type="hidden"/></fieldset>)
      end

      it 'with group label' do
        element = builder.custom_stacked_checkbox(
          :public,
          label: 'Public',
          collection: collection_array
        )
        element.to_s.must_equal %(<fieldset class="form-group"><legend class="form-control-label">Public</legend><div class="custom-controls-stacked"><label class="custom-control custom-checkbox"><input type="checkbox" value="1" name="public[]" id="public_1" class="custom-control-input"/><span class=\"custom-control-indicator\"></span><span class=\"custom-control-description\">Option 1</span></label><label class="custom-control custom-checkbox"><input type="checkbox" value="2" name="public[]" id="public_2" class="custom-control-input"/><span class=\"custom-control-indicator\"></span><span class=\"custom-control-description\">Option 2</span></label></div><input value="" name="public[]" type="hidden"/></fieldset>)
      end

      it 'with hint' do
        element = builder.custom_stacked_checkbox(
          :public,
          collection: collection_array,
          hint: 'Some helpful words'
        )
        element.to_s.must_equal %(<fieldset class="form-group"><div class="custom-controls-stacked"><label class="custom-control custom-checkbox"><input type="checkbox" value="1" aria-describedby="public_hint" name="public[]" id="public_1" class="custom-control-input"/><span class=\"custom-control-indicator\"></span><span class=\"custom-control-description\">Option 1</span></label><label class="custom-control custom-checkbox"><input type="checkbox" value="2" aria-describedby="public_hint" name="public[]" id="public_2" class="custom-control-input"/><span class=\"custom-control-indicator\"></span><span class=\"custom-control-description\">Option 2</span></label></div><input value="" name="public[]" type="hidden"/><small id="public_hint" class="form-text text-muted">Some helpful words</small></fieldset>)
      end

      it 'with error' do
        element = builder.custom_stacked_checkbox(
          :public,
          collection: collection_array,
          error: 'Something nasty happened'
        )
        element.to_s.must_equal %(<fieldset class="form-group has-danger"><div class="custom-controls-stacked"><label class="custom-control custom-checkbox"><input type="checkbox" value="1" name="public[]" id="public_1" class="custom-control-input"/><span class=\"custom-control-indicator\"></span><span class=\"custom-control-description\">Option 1</span></label><label class="custom-control custom-checkbox"><input type="checkbox" value="2" name="public[]" id="public_2" class="custom-control-input"/><span class=\"custom-control-indicator\"></span><span class=\"custom-control-description\">Option 2</span></label></div><input value="" name="public[]" type="hidden"/><div class="form-control-feedback">Something nasty happened</div></fieldset>)
      end

      it 'all together!' do
        element = builder.custom_stacked_checkbox(
          :public,
          label: 'Public',
          collection: collection_array,
          hint: 'Some helpful words',
          error: 'Something nasty happened'
        )
        element.to_s.must_equal %(<fieldset class="form-group has-danger"><legend class="form-control-label">Public</legend><div class="custom-controls-stacked"><label class="custom-control custom-checkbox"><input type="checkbox" value="1" aria-describedby="public_hint" name="public[]" id="public_1" class="custom-control-input"/><span class=\"custom-control-indicator\"></span><span class=\"custom-control-description\">Option 1</span></label><label class="custom-control custom-checkbox"><input type="checkbox" value="2" aria-describedby="public_hint" name="public[]" id="public_2" class="custom-control-input"/><span class="custom-control-indicator"></span><span class=\"custom-control-description\">Option 2</span></label></div><input value="" name="public[]" type="hidden"/><small id="public_hint" class="form-text text-muted">Some helpful words</small><div class="form-control-feedback">Something nasty happened</div></fieldset>)
      end
    end
  end

  describe Formular::Element::Bootstrap4::Inline::CustomRadio do
    it 'with value and label' do
      element = builder.custom_radio(:public, label: 'Public', value: 1)
      element.to_s.must_equal %(<fieldset class="form-group"><label class="custom-control custom-radio"><input value="1" name="public" id="public" type="radio" class="custom-control-input"/><span class=\"custom-control-indicator\"></span><span class=\"custom-control-description\">Public</span></label></fieldset>)
    end

    it 'with hint' do
      element = builder.custom_radio(
        :public,
        label: 'Public',
        value: 1,
        hint: 'Some helpful words'
      )
      element.to_s.must_equal %(<fieldset class="form-group"><label class="custom-control custom-radio"><input value="1" name="public" id="public" type="radio" aria-describedby="public_hint" class="custom-control-input"/><span class=\"custom-control-indicator\"></span><span class=\"custom-control-description\">Public</span></label><small id="public_hint" class="form-text text-muted">Some helpful words</small></fieldset>)
    end

    it 'with error' do
      element = builder.custom_radio(
        :public,
        label: 'Public',
        value: 1,
        error: 'Something nasty happened'
      )
      element.to_s.must_equal %(<fieldset class="form-group has-danger"><label class="custom-control custom-radio"><input value="1" name="public" id="public" type="radio" class="custom-control-input"/><span class=\"custom-control-indicator\"></span><span class=\"custom-control-description\">Public</span></label><div class="form-control-feedback">Something nasty happened</div></fieldset>)
    end

    it 'all together!' do
      element = builder.custom_radio(
        :public,
        label: 'Public',
        value: 1,
        error: 'Something nasty happened',
        hint: 'Some helpful words'
      )
      element.to_s.must_equal %(<fieldset class="form-group has-danger"><label class="custom-control custom-radio"><input value="1" name="public" id="public" type="radio" aria-describedby="public_hint" class="custom-control-input"/><span class=\"custom-control-indicator\"></span><span class=\"custom-control-description\">Public</span></label><small id="public_hint" class="form-text text-muted">Some helpful words</small><div class="form-control-feedback">Something nasty happened</div></fieldset>)
    end

    describe 'with collection' do
      it 'no group label' do
        element = builder.custom_radio(:public, collection: collection_array)
        element.to_s.must_equal %(<fieldset class="form-group"><label class="custom-control custom-radio"><input type="radio" name="public" value="1" id="public_1" class="custom-control-input"/><span class=\"custom-control-indicator\"></span><span class=\"custom-control-description\">Option 1</span></label><label class="custom-control custom-radio"><input type="radio" name="public" value="2" id="public_2" class="custom-control-input"/><span class=\"custom-control-indicator\"></span><span class=\"custom-control-description\">Option 2</span></label></fieldset>)
      end

      it 'with group label' do
        element = builder.custom_radio(
          :public,
          label: 'Public',
          collection: collection_array
        )
        element.to_s.must_equal %(<fieldset class="form-group"><legend class="form-control-label">Public</legend><label class="custom-control custom-radio"><input type="radio" name="public" value="1" id="public_1" class="custom-control-input"/><span class=\"custom-control-indicator\"></span><span class=\"custom-control-description\">Option 1</span></label><label class="custom-control custom-radio"><input type="radio" name="public" value="2" id="public_2" class="custom-control-input"/><span class=\"custom-control-indicator\"></span><span class=\"custom-control-description\">Option 2</span></label></fieldset>)
      end

      it 'with hint' do
        element = builder.custom_radio(
          :public,
          collection: collection_array,
          hint: 'Some helpful words'
        )
        element.to_s.must_equal %(<fieldset class="form-group"><label class="custom-control custom-radio"><input type="radio" aria-describedby="public_hint" name="public" value="1" id="public_1" class="custom-control-input"/><span class=\"custom-control-indicator\"></span><span class=\"custom-control-description\">Option 1</span></label><label class="custom-control custom-radio"><input type="radio" aria-describedby="public_hint" name="public" value="2" id="public_2" class="custom-control-input"/><span class=\"custom-control-indicator\"></span><span class=\"custom-control-description\">Option 2</span></label><small id="public_hint" class="form-text text-muted">Some helpful words</small></fieldset>)
      end

      it 'with error' do
        element = builder.custom_radio(
          :public,
          collection: collection_array,
          error: 'Something nasty happened'
        )
        element.to_s.must_equal %(<fieldset class="form-group has-danger"><label class="custom-control custom-radio"><input type="radio" name="public" value="1" id="public_1" class="custom-control-input"/><span class=\"custom-control-indicator\"></span><span class=\"custom-control-description\">Option 1</span></label><label class="custom-control custom-radio"><input type="radio" name="public" value="2" id="public_2" class="custom-control-input"/><span class=\"custom-control-indicator\"></span><span class=\"custom-control-description\">Option 2</span></label><div class="form-control-feedback">Something nasty happened</div></fieldset>)
      end

      it 'all together!' do
        element = builder.custom_radio(
          :public,
          label: 'Public',
          collection: collection_array,
          hint: 'Some helpful words',
          error: 'Something nasty happened'
        )
        element.to_s.must_equal %(<fieldset class="form-group has-danger"><legend class="form-control-label">Public</legend><label class="custom-control custom-radio"><input type="radio" aria-describedby="public_hint" name="public" value="1" id="public_1" class="custom-control-input"/><span class=\"custom-control-indicator\"></span><span class=\"custom-control-description\">Option 1</span></label><label class="custom-control custom-radio"><input type="radio" aria-describedby="public_hint" name="public" value="2" id="public_2" class="custom-control-input"/><span class="custom-control-indicator"></span><span class=\"custom-control-description\">Option 2</span></label><small id="public_hint" class="form-text text-muted">Some helpful words</small><div class="form-control-feedback">Something nasty happened</div></fieldset>)
      end
    end
  end

  describe Formular::Element::Bootstrap4::CustomStackedRadio do
    it 'with value and label' do
      element = builder.custom_stacked_radio(:public, label: 'Public', value: 1)
      element.to_s.must_equal %(<fieldset class="form-group"><div class="custom-controls-stacked"><label class="custom-control custom-radio"><input value="1" name="public" id="public" type="radio" class="custom-control-input"/><span class=\"custom-control-indicator\"></span><span class=\"custom-control-description\">Public</span></label></div></fieldset>)
    end

    it 'with hint' do
      element = builder.custom_stacked_radio(
        :public,
        label: 'Public',
        value: 1,
        hint: 'Some helpful words'
      )
      element.to_s.must_equal %(<fieldset class="form-group"><div class="custom-controls-stacked"><label class="custom-control custom-radio"><input value="1" name="public" id="public" type="radio" aria-describedby="public_hint" class="custom-control-input"/><span class=\"custom-control-indicator\"></span><span class=\"custom-control-description\">Public</span></label></div><small id="public_hint" class="form-text text-muted">Some helpful words</small></fieldset>)
    end

    it 'with error' do
      element = builder.custom_stacked_radio(
        :public,
        label: 'Public',
        value: 1,
        error: 'Something nasty happened'
      )
      element.to_s.must_equal %(<fieldset class="form-group has-danger"><div class="custom-controls-stacked"><label class="custom-control custom-radio"><input value="1" name="public" id="public" type="radio" class="custom-control-input"/><span class=\"custom-control-indicator\"></span><span class=\"custom-control-description\">Public</span></label></div><div class="form-control-feedback">Something nasty happened</div></fieldset>)
    end

    it 'all together!' do
      element = builder.custom_stacked_radio(
        :public,
        label: 'Public',
        value: 1,
        error: 'Something nasty happened',
        hint: 'Some helpful words'
      )
      element.to_s.must_equal %(<fieldset class="form-group has-danger"><div class="custom-controls-stacked"><label class="custom-control custom-radio"><input value="1" name="public" id="public" type="radio" aria-describedby="public_hint" class="custom-control-input"/><span class=\"custom-control-indicator\"></span><span class=\"custom-control-description\">Public</span></label></div><small id="public_hint" class="form-text text-muted">Some helpful words</small><div class="form-control-feedback">Something nasty happened</div></fieldset>)
    end

    describe 'with collection' do
      it 'no group label' do
        element = builder.custom_stacked_radio(:public, collection: collection_array)
        element.to_s.must_equal %(<fieldset class="form-group"><div class="custom-controls-stacked"><label class="custom-control custom-radio"><input type="radio" name="public" value="1" id="public_1" class="custom-control-input"/><span class=\"custom-control-indicator\"></span><span class=\"custom-control-description\">Option 1</span></label><label class="custom-control custom-radio"><input type="radio" name="public" value="2" id="public_2" class="custom-control-input"/><span class=\"custom-control-indicator\"></span><span class=\"custom-control-description\">Option 2</span></label></div></fieldset>)
      end

      it 'with group label' do
        element = builder.custom_stacked_radio(
          :public,
          label: 'Public',
          collection: collection_array
        )
        element.to_s.must_equal %(<fieldset class="form-group"><legend class="form-control-label">Public</legend><div class="custom-controls-stacked"><label class="custom-control custom-radio"><input type="radio" name="public" value="1" id="public_1" class="custom-control-input"/><span class=\"custom-control-indicator\"></span><span class=\"custom-control-description\">Option 1</span></label><label class="custom-control custom-radio"><input type="radio" name="public" value="2" id="public_2" class="custom-control-input"/><span class=\"custom-control-indicator\"></span><span class=\"custom-control-description\">Option 2</span></label></div></fieldset>)
      end

      it 'with hint' do
        element = builder.custom_stacked_radio(
          :public,
          collection: collection_array,
          hint: 'Some helpful words'
        )
        element.to_s.must_equal %(<fieldset class="form-group"><div class="custom-controls-stacked"><label class="custom-control custom-radio"><input type="radio" aria-describedby="public_hint" name="public" value="1" id="public_1" class="custom-control-input"/><span class=\"custom-control-indicator\"></span><span class=\"custom-control-description\">Option 1</span></label><label class="custom-control custom-radio"><input type="radio" aria-describedby="public_hint" name="public" value="2" id="public_2" class="custom-control-input"/><span class=\"custom-control-indicator\"></span><span class=\"custom-control-description\">Option 2</span></label></div><small id="public_hint" class="form-text text-muted">Some helpful words</small></fieldset>)
      end

      it 'with error' do
        element = builder.custom_stacked_radio(
          :public,
          collection: collection_array,
          error: 'Something nasty happened'
        )
        element.to_s.must_equal %(<fieldset class="form-group has-danger"><div class="custom-controls-stacked"><label class="custom-control custom-radio"><input type="radio" name="public" value="1" id="public_1" class="custom-control-input"/><span class=\"custom-control-indicator\"></span><span class=\"custom-control-description\">Option 1</span></label><label class="custom-control custom-radio"><input type="radio" name="public" value="2" id="public_2" class="custom-control-input"/><span class=\"custom-control-indicator\"></span><span class=\"custom-control-description\">Option 2</span></label></div><div class="form-control-feedback">Something nasty happened</div></fieldset>)
      end

      it 'all together!' do
        element = builder.custom_stacked_radio(
          :public,
          label: 'Public',
          collection: collection_array,
          hint: 'Some helpful words',
          error: 'Something nasty happened'
        )
        element.to_s.must_equal %(<fieldset class="form-group has-danger"><legend class="form-control-label">Public</legend><div class="custom-controls-stacked"><label class="custom-control custom-radio"><input type="radio" aria-describedby="public_hint" name="public" value="1" id="public_1" class="custom-control-input"/><span class=\"custom-control-indicator\"></span><span class=\"custom-control-description\">Option 1</span></label><label class="custom-control custom-radio"><input type="radio" aria-describedby="public_hint" name="public" value="2" id="public_2" class="custom-control-input"/><span class="custom-control-indicator"></span><span class=\"custom-control-description\">Option 2</span></label></div><small id="public_hint" class="form-text text-muted">Some helpful words</small><div class="form-control-feedback">Something nasty happened</div></fieldset>)
      end
    end
  end

  describe Formular::Element::Bootstrap4::CustomSelect do
    it '#to_s with value' do
      element = builder.custom_select(:name, value: 1, collection: collection_array)
      element.to_s.must_equal %(<fieldset class="form-group"><div><select name="name" id="name" class="custom-select"><option value="1" selected="selected">Option 1</option><option value="2">Option 2</option></select></div></fieldset>)
    end

    it '#to_s with label' do
      element = builder.custom_select(:name, label: 'Name', collection: collection_array)
      element.to_s.must_equal %(<fieldset class="form-group"><label class="form-control-label" for="name">Name</label><div><select name="name" id="name" class="custom-select"><option value="1">Option 1</option><option value="2">Option 2</option></select></div></fieldset>)
    end

    it '#to_s with hint' do
      element = builder.custom_select(:name, hint: 'Some helpful words', collection: collection_array)
      element.to_s.must_equal %(<fieldset class="form-group"><div><select name="name" id="name" aria-describedby="name_hint" class="custom-select"><option value="1">Option 1</option><option value="2">Option 2</option></select></div><small id="name_hint" class="form-text text-muted">Some helpful words</small></fieldset>)
    end

    it '#to_s with error' do
      element = builder.custom_select(:name, error: 'Something nasty happened', collection: collection_array)
      element.to_s.must_equal %(<fieldset class="form-group has-danger"><div><select name="name" id="name" class="custom-select"><option value="1">Option 1</option><option value="2">Option 2</option></select></div><div class="form-control-feedback">Something nasty happened</div></fieldset>)
    end

    it '#to_s all together!' do
      element = builder.custom_select(
        :name,
        value: 1,
        label: 'Name',
        error: 'Something nasty happened',
        hint: 'Some helpful words',
        collection: collection_array
      )
      element.to_s.must_equal %(<fieldset class="form-group has-danger"><label class="form-control-label" for="name">Name</label><div><select name="name" id="name" aria-describedby="name_hint" class="custom-select"><option value="1" selected="selected">Option 1</option><option value="2">Option 2</option></select></div><small id="name_hint" class="form-text text-muted">Some helpful words</small><div class="form-control-feedback">Something nasty happened</div></fieldset>)
    end
  end

  describe Formular::Element::Bootstrap4::CustomFile do
    it '#to_s with label' do
      element = builder.custom_file(:doc, label: 'Document')
      element.to_s.must_equal %(<fieldset class="form-group"><label class="form-control-label" for="doc">Document</label><div><label class="custom-file"><input name="doc" id="doc" class="custom-file-input" type="file"/><span class="custom-file-control"></span></label></div></fieldset>)
    end

    it '#to_s with hint' do
      element = builder.custom_file(:doc, hint: 'Some helpful words')
      element.to_s.must_equal %(<fieldset class="form-group"><div><label class="custom-file"><input name="doc" id="doc" aria-describedby="doc_hint" class="custom-file-input" type="file"/><span class="custom-file-control"></span></label></div><small id="doc_hint" class="form-text text-muted">Some helpful words</small></fieldset>)
    end

    it '#to_s with error' do
      element = builder.custom_file(:doc, error: 'Something nasty happened')
      element.to_s.must_equal %(<fieldset class="form-group has-danger"><div><label class="custom-file"><input name="doc" id="doc" class="custom-file-input" type="file"/><span class="custom-file-control"></span></label></div><div class="form-control-feedback">Something nasty happened</div></fieldset>)
    end

    it '#to_s all together!' do
      element = builder.custom_file(
        :doc,
        label: 'Document',
        error: 'Something nasty happened',
        hint: 'Some helpful words'
      )
      element.to_s.must_equal %(<fieldset class="form-group has-danger"><label class="form-control-label" for="doc">Document</label><div><label class="custom-file"><input name="doc" id="doc" aria-describedby="doc_hint" class="custom-file-input" type="file"/><span class="custom-file-control"></span></label></div><small id="doc_hint" class="form-text text-muted">Some helpful words</small><div class="form-control-feedback">Something nasty happened</div></fieldset>)
    end
  end
end