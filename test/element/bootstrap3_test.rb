require 'test_helper'
require 'formular/builders/bootstrap3'
require 'formular/element/bootstrap3'

describe Formular::Element::Bootstrap3 do
  let(:builder) { Formular::Builders::Bootstrap3.new }
  let(:collection_array) { COLLECTION_ARRAY }

  describe Formular::Element::Bootstrap3::ErrorNotification do
    let(:builder) { Formular::Builders::Bootstrap3.new(errors: { name: ['some error'] }) }

    it 'default message' do
      element = builder.error_notification
      element.to_s.must_equal %(<div class="alert alert-danger" role="alert">Please review the problems below:</div>)
    end

    it 'custom message' do
      element = builder.error_notification(message: 'My message:')
      element.to_s.must_equal %(<div class="alert alert-danger" role="alert">My message:</div>)
    end

    it 'respects html attributes' do
      element = builder.error_notification(data: { some_key: 'true' }, class: ['hey', 'there'])
      element.to_s.must_equal %(<div data-some-key="true" class="hey there alert alert-danger" role="alert">Please review the problems below:</div>)
    end
  end

  describe Formular::Element::Bootstrap3::Icon do
    it "#to_s" do
      element = builder.icon(name: :plus)
      element.to_s.must_equal %(<span class="glyphicon glyphicon-plus"></span>)
    end
  end

  describe Formular::Element::Bootstrap3::Submit do
    it "#to_s" do
      element = builder.submit(content: 'Go Go Go!!')
      element.to_s.must_equal %(<button class="btn btn-default" type="submit">Go Go Go!!</button>)
    end
  end

  describe Formular::Element::Bootstrap3::Input do
    it '#to_s with value' do
      element = builder.input(:name, value: 'Joseph Smith')
      element.to_s.must_equal %(<div class="form-group"><input value="Joseph Smith" name="name" id="name" type="text" class="form-control"/></div>)
    end

    it '#to_s with label' do
      element = builder.input(:name, label: 'Name')
      element.to_s.must_equal %(<div class="form-group"><label for="name" class="control-label">Name</label><input name="name" id="name" type="text" class="form-control"/></div>)
    end

    it '#to_s with hint' do
      element = builder.input(:name, hint: 'Some helpful words')
      element.to_s.must_equal %(<div class="form-group"><input name="name" id="name" type="text" aria-describedby="name_hint" class="form-control"/><span id="name_hint" class="help-block">Some helpful words</span></div>)
    end

    it '#to_s with error' do
      element = builder.input(:name, error: 'Something nasty happened')
      element.to_s.must_equal %(<div class="form-group has-error"><input name="name" id="name" type="text" class="form-control"/><span class="help-block">Something nasty happened</span></div>)
    end

    it '#to_s all together!' do
      element = builder.input(
        :name,
        value: 'Joseph Smith',
        label: 'Name',
        error: 'Something nasty happened',
        hint: 'Some helpful words'
      )
      element.to_s.must_equal %(<div class="form-group has-error"><label for="name" class="control-label">Name</label><input value="Joseph Smith" name="name" id="name" type="text" aria-describedby="name_hint" class="form-control"/><span id="name_hint" class="help-block">Some helpful words</span><span class="help-block">Something nasty happened</span></div>)
    end

    describe 'file' do
      it '#to_s with label' do
        element = builder.input(:doc, type: :file, label: 'Document')
        element.to_s.must_equal %(<div class="form-group"><label for="doc" class="control-label">Document</label><input type="file" name="doc" id="doc"/></div>)
      end

      it '#to_s with hint' do
        element = builder.input(:doc, type: :file, hint: 'Some helpful words')
        element.to_s.must_equal %(<div class="form-group"><input type="file" name="doc" id="doc" aria-describedby="doc_hint"/><span id="doc_hint" class="help-block">Some helpful words</span></div>)
      end

      it '#to_s with error' do
        element = builder.input(:doc, type: :file, error: 'Something nasty happened')
        element.to_s.must_equal %(<div class="form-group has-error"><input type="file" name="doc" id="doc"/><span class="help-block">Something nasty happened</span></div>)
      end

      it '#to_s all together!' do
        element = builder.input(
          :doc,
          type: :file,
          label: 'Document',
          error: 'Something nasty happened',
          hint: 'Some helpful words'
        )
        element.to_s.must_equal %(<div class="form-group has-error"><label for="doc" class="control-label">Document</label><input type="file" name="doc" id="doc" aria-describedby="doc_hint"/><span id="doc_hint" class="help-block">Some helpful words</span><span class="help-block">Something nasty happened</span></div>)
      end
    end
  end

  describe Formular::Element::Bootstrap3::Select do
    it '#to_s with value' do
      element = builder.select(:name, value: 1, collection: collection_array)
      element.to_s.must_equal %(<div class="form-group"><select name="name" id="name" class="form-control"><option value="1" selected="selected">Option 1</option><option value="2">Option 2</option></select></div>)
    end

    it '#to_s with label' do
      element = builder.select(:name, label: 'Name', collection: collection_array)
      element.to_s.must_equal %(<div class="form-group"><label for="name" class="control-label">Name</label><select name="name" id="name" class="form-control"><option value="1">Option 1</option><option value="2">Option 2</option></select></div>)
    end

    it '#to_s with hint' do
      element = builder.select(:name, hint: 'Some helpful words', collection: collection_array)
      element.to_s.must_equal %(<div class="form-group"><select name="name" id="name" aria-describedby="name_hint" class="form-control"><option value="1">Option 1</option><option value="2">Option 2</option></select><span id="name_hint" class="help-block">Some helpful words</span></div>)
    end

    it '#to_s with error' do
      element = builder.select(:name, error: 'Something nasty happened', collection: collection_array)
      element.to_s.must_equal %(<div class="form-group has-error"><select name="name" id="name" class="form-control"><option value="1">Option 1</option><option value="2">Option 2</option></select><span class="help-block">Something nasty happened</span></div>)
    end

    it '#to_s all together!' do
      element = builder.select(
        :name,
        value: 1,
        label: 'Name',
        error: 'Something nasty happened',
        hint: 'Some helpful words',
        collection: collection_array
      )
      element.to_s.must_equal %(<div class="form-group has-error"><label for="name" class="control-label">Name</label><select name="name" id="name" aria-describedby="name_hint" class="form-control"><option value="1" selected="selected">Option 1</option><option value="2">Option 2</option></select><span id="name_hint" class="help-block">Some helpful words</span><span class="help-block">Something nasty happened</span></div>)
    end
  end

  describe 'independent errors' do
    let(:builder) do
      Formular::Builders::Bootstrap3.new(
        errors: { body: ['This really isn\'t good enough!'] }
      )
    end

    it '#error should return the error element for :body' do
      element = builder.error(:body)
      element.to_s.must_equal %(<span class="help-block">This really isn&#39;t good enough!</span>)
    end
  end

  describe 'independent hints' do
    it '#error should return the error element for :body' do
      element = builder.hint(content: 'Something helpful')
      element.to_s.must_equal %(<span class="help-block">Something helpful</span>)
    end
  end

  describe 'independent labels' do
    it '#error should return the error element for :body' do
      element = builder.label(:body, content: 'Some words...')
      element.to_s.must_equal %(<label for="body" class="control-label">Some words...</label>)
    end
  end
end
