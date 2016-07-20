require 'test_helper'
require 'formular/builders/bootstrap3'
require 'formular/elements/bootstrap3'

describe Formular::Elements::Bootstrap3 do
  let(:builder) { Formular::Builders::Bootstrap3.new }
  let(:collection_array) { [['Option 1', 1], ['Option 2', 2]] }

  describe Formular::Elements::Bootstrap3::Submit do
    it "#to_s" do
      element = builder.submit(value: 'Go Go Go!!')
      element.to_s.must_equal %(<button class="btn btn-default" type="submit">Go Go Go!!</button>)
    end
  end

  describe Formular::Elements::Bootstrap3::Input do
    it '#to_s with value' do
      element = builder.input(:name, value: 'Joseph Smith')
      element.to_s.must_equal %(<div class="form-group"><input name="name" id="name" type="text" class="form-control" value="Joseph Smith"/></div>)
    end

    it '#to_s with label' do
      element = builder.input(:name, label: 'Name')
      element.to_s.must_equal %(<div class="form-group"><label for="name" class="control-label">Name</label><input name="name" id="name" type="text" class="form-control"/></div>)
    end

    it '#to_s with hint' do
      element = builder.input(:name, hint: 'Some helpful words')
      element.to_s.must_equal %(<div class="form-group"><input name="name" id="name" type="text" aria-describedby="name_hint" class="form-control"/><span class="help-block" id="name_hint">Some helpful words</span></div>)
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
      element.to_s.must_equal %(<div class="form-group has-error"><label for="name" class="control-label">Name</label><input name="name" id="name" type="text" aria-describedby="name_hint" class="form-control" value="Joseph Smith"/><span class="help-block" id="name_hint">Some helpful words</span><span class="help-block">Something nasty happened</span></div>)
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
      element.to_s.must_equal %(<span class="help-block">This really isn't good enough!</span>)
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
