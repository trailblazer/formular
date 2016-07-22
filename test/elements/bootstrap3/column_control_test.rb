require 'test_helper'
require 'formular/builders/bootstrap3'
require 'formular/elements/bootstrap3'
require 'formular/elements/bootstrap3/column_control'

describe 'Bootstrap3::ColumnControl' do
  let(:builder) { Formular::Builders::Bootstrap3.new(errors: { body: ['some nasty error'] }) }

  describe 'inline columns' do
    it 'inputs' do
      form = builder.form(action: '/questions/13') do |f|
        f.row do
          concat f.input(:body, label: 'Body', inline_col_class: ['col-md-6'], hint: 'some handy hint')
          concat f.input(:uuid, inline_col_class: ['col-md-2'])
          concat f.input(:public, label: 'Public', inline_col_class: ['col-md-4'])
        end
      end
      form.to_s.must_equal %(<form action="/questions/13" method="post" accept-charset=\"utf-8\"><input name=\"utf8\" type=\"hidden\" value=\"✓\"/><div class="row"><div class="col-md-6 form-group has-error"><label for="body" class="control-label">Body</label><input name="body" id="body" type="text" aria-describedby="body_hint" class="form-control"/><span id="body_hint" class="help-block">some handy hint</span><span class="help-block">some nasty error</span></div><div class="col-md-2 form-group"><input name="uuid" id="uuid" type="text" class="form-control"/></div><div class="col-md-4 form-group"><label for="public" class="control-label">Public</label><input name="public" id="public" type="text" class="form-control"/></div></div></form>)
    end

    it 'select' do
      collection_array = [['Option 1', 1], ['Option 2', 2]]

      form = builder.form(action: '/questions/13') do |f|
        f.row do
          concat f.select(:body, label: 'Body', inline_col_class: ['col-md-6'], hint: 'some handy hint', collection: collection_array)
          concat f.select(:uuid, inline_col_class: ['col-md-2'], collection: collection_array)
          concat f.select(:public, label: 'Public', inline_col_class: ['col-md-4'], collection: collection_array)
        end
      end
      form.to_s.must_equal %(<form action="/questions/13" method="post" accept-charset=\"utf-8\"><input name=\"utf8\" type=\"hidden\" value=\"✓\"/><div class="row"><div class="col-md-6 form-group has-error"><label for="body" class="control-label">Body</label><select name="body" id="body" aria-describedby="body_hint" class="form-control"><option value="1">Option 1</option><option value="2">Option 2</option></select><span id="body_hint" class="help-block">some handy hint</span><span class="help-block">some nasty error</span></div><div class="col-md-2 form-group"><select name="uuid" id="uuid" class="form-control"><option value="1">Option 1</option><option value="2">Option 2</option></select></div><div class="col-md-4 form-group"><label for="public" class="control-label">Public</label><select name="public" id="public" class="form-control"><option value="1">Option 1</option><option value="2">Option 2</option></select></div></div></form>)
    end

    it 'textarea' do
      form = builder.form(action: '/questions/13') do |f|
        f.row do
          concat f.textarea(:body, label: 'Body', inline_col_class: ['col-md-6'], hint: 'some handy hint')
          concat f.textarea(:uuid, inline_col_class: ['col-md-2'])
          concat f.textarea(:public, label: 'Public', inline_col_class: ['col-md-4'])
        end
      end
      form.to_s.must_equal %(<form action="/questions/13" method="post" accept-charset=\"utf-8\"><input name=\"utf8\" type=\"hidden\" value=\"✓\"/><div class="row"><div class="col-md-6 form-group has-error"><label for="body" class="control-label">Body</label><textarea name="body" id="body" aria-describedby="body_hint" class="form-control"></textarea><span id="body_hint" class="help-block">some handy hint</span><span class="help-block">some nasty error</span></div><div class="col-md-2 form-group"><textarea name="uuid" id="uuid" class="form-control"></textarea></div><div class="col-md-4 form-group"><label for="public" class="control-label">Public</label><textarea name="public" id="public" class="form-control"></textarea></div></div></form>)
    end
  end
end