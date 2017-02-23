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
      element.to_s.must_equal %(<fieldset class="form-group"><label for="name">Name</label><input name="name" id="name" type="text" class="form-control"/></fieldset>)
    end

    it '#to_s with hint' do
      element = builder.input(:name, hint: 'Some helpful words')
      element.to_s.must_equal %(<fieldset class="form-group"><input name="name" id="name" type="text" aria-describedby="name_hint" class="form-control"/><small id="name_hint" class="text-muted">Some helpful words</small></fieldset>)
    end

    it '#to_s with error' do
      element = builder.input(:name, error: 'Something nasty happened')
      element.to_s.must_equal %(<fieldset class="form-group has-danger"><input name="name" id="name" type="text" class="form-control"/><span class="form-control-feedback">Something nasty happened</span></fieldset>)
    end

    it '#to_s all together!' do
      element = builder.input(
        :name,
        value: 'Joseph Smith',
        label: 'Name',
        error: 'Something nasty happened',
        hint: 'Some helpful words'
      )
      element.to_s.must_equal %(<fieldset class="form-group has-danger"><label for="name">Name</label><input value="Joseph Smith" name="name" id="name" type="text" aria-describedby="name_hint" class="form-control"/><small id="name_hint" class="text-muted">Some helpful words</small><span class="form-control-feedback">Something nasty happened</span></fieldset>)
    end

    describe 'file' do
      it '#to_s with label' do
        element = builder.input(:doc, type: :file, label: 'Document')
        element.to_s.must_equal %(<fieldset class="form-group"><label for="doc">Document</label><input type="file" name="doc" id="doc" class="form-control-file"/></fieldset>)
      end

      it '#to_s with hint' do
        element = builder.input(:doc, type: :file, hint: 'Some helpful words')
        element.to_s.must_equal %(<fieldset class="form-group"><input type="file" name="doc" id="doc" aria-describedby="doc_hint" class="form-control-file"/><small id="doc_hint" class="text-muted">Some helpful words</small></fieldset>)
      end

      it '#to_s with error' do
        element = builder.input(:doc, type: :file, error: 'Something nasty happened')
        element.to_s.must_equal %(<fieldset class="form-group has-danger"><input type="file" name="doc" id="doc" class="form-control-file"/><span class="form-control-feedback">Something nasty happened</span></fieldset>)
      end

      it '#to_s all together!' do
        element = builder.input(
          :doc,
          type: :file,
          label: 'Document',
          error: 'Something nasty happened',
          hint: 'Some helpful words'
        )
        element.to_s.must_equal %(<fieldset class="form-group has-danger"><label for="doc">Document</label><input type="file" name="doc" id="doc" aria-describedby="doc_hint" class="form-control-file"/><small id="doc_hint" class="text-muted">Some helpful words</small><span class="form-control-feedback">Something nasty happened</span></fieldset>)
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
      element.to_s.must_equal %(<span class="form-control-feedback">This really isn&#39;t good enough!</span>)
    end
  end

  describe 'independent hints' do
    it '#error should return the error element for :body' do
      element = builder.hint(content: 'Something helpful')
      element.to_s.must_equal %(<small class="text-muted">Something helpful</small>)
    end
  end

  describe 'independent labels' do
    it '#error should return the error element for :body' do
      element = builder.label(:body, content: 'Some words...')
      element.to_s.must_equal %(<label for="body">Some words...</label>)
    end
  end
end
