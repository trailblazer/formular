require 'test_helper'
require 'formular/builders/bootstrap4'
require 'formular/element/bootstrap4'

describe Formular::Element::Bootstrap4 do
  let(:builder) { Formular::Builders::Bootstrap4.new }
  let(:collection_array) { COLLECTION_ARRAY }

  describe Formular::Element::Bootstrap4::Input do
    it '#to_s with value' do
      element = builder.input(:name, value: 'Joseph Smith')
      element.to_s.must_equal %(<fieldset class="form-group"><input value="Joseph Smith" name="name" id="name" type="text" class="form-control"/></fieldset>)
    end

    it '#to_s with label' do
      element = builder.input(:name, label: 'Name')
      element.to_s.must_equal %(<fieldset class="form-group"><label class="form-control-label" for="name">Name</label><input name="name" id="name" type="text" class="form-control"/></fieldset>)
    end

    it '#to_s with hint' do
      element = builder.input(:name, hint: 'Some helpful words')
      element.to_s.must_equal %(<fieldset class="form-group"><input name="name" id="name" type="text" aria-describedby="name_hint" class="form-control"/><small id="name_hint" class="form-text text-muted">Some helpful words</small></fieldset>)
    end

    it '#to_s with error' do
      element = builder.input(:name, error: 'Something nasty happened')
      element.to_s.must_equal %(<fieldset class="form-group has-danger"><input name="name" id="name" type="text" class="form-control form-control-danger"/><div class="form-control-feedback">Something nasty happened</div></fieldset>)
    end

    it '#to_s all together!' do
      element = builder.input(
        :name,
        value: 'Joseph Smith',
        label: 'Name',
        error: 'Something nasty happened',
        hint: 'Some helpful words'
      )
      element.to_s.must_equal %(<fieldset class="form-group has-danger"><label class="form-control-label" for="name">Name</label><input value="Joseph Smith" name="name" id="name" type="text" aria-describedby="name_hint" class="form-control form-control-danger"/><small id="name_hint" class="form-text text-muted">Some helpful words</small><div class="form-control-feedback">Something nasty happened</div></fieldset>)
    end

    describe 'file' do
      it '#to_s with label' do
        element = builder.input(:doc, type: :file, label: 'Document')
        element.to_s.must_equal %(<fieldset class="form-group"><label class="form-control-label" for="doc">Document</label><input type="file" name="doc" id="doc" class="form-control-file"/></fieldset>)
      end

      it '#to_s with hint' do
        element = builder.input(:doc, type: :file, hint: 'Some helpful words')
        element.to_s.must_equal %(<fieldset class="form-group"><input type="file" name="doc" id="doc" aria-describedby="doc_hint" class="form-control-file"/><small id="doc_hint" class="form-text text-muted">Some helpful words</small></fieldset>)
      end

      it '#to_s with error' do
        element = builder.input(:doc, type: :file, error: 'Something nasty happened')
        element.to_s.must_equal %(<fieldset class="form-group has-danger"><input type="file" name="doc" id="doc" class="form-control-file"/><div class="form-control-feedback">Something nasty happened</div></fieldset>)
      end

      it '#to_s all together!' do
        element = builder.input(
          :doc,
          type: :file,
          label: 'Document',
          error: 'Something nasty happened',
          hint: 'Some helpful words'
        )
        element.to_s.must_equal %(<fieldset class="form-group has-danger"><label class="form-control-label" for="doc">Document</label><input type="file" name="doc" id="doc" aria-describedby="doc_hint" class="form-control-file"/><small id="doc_hint" class="form-text text-muted">Some helpful words</small><div class="form-control-feedback">Something nasty happened</div></fieldset>)
      end
    end

  end

  describe 'independent errors' do
    let(:builder) do
      Formular::Builders::Bootstrap4.new(
        errors: { body: ['This really isn\'t good enough!'] }
      )
    end

    it '#error should return the error element for :body' do
      element = builder.error(:body)
      element.to_s.must_equal %(<div class="form-control-feedback">This really isn&#39;t good enough!</div>)
    end
  end

  describe 'independent hints' do
    it '#error should return the hint element for :body' do
      element = builder.hint(content: 'Something helpful')
      element.to_s.must_equal %(<small class="form-text text-muted">Something helpful</small>)
    end
  end

  describe 'independent labels' do
    it '#error should return the label element for :body' do
      element = builder.label(:body, content: 'Some words...')
      element.to_s.must_equal %(<label for="body">Some words...</label>)
    end
  end
end
