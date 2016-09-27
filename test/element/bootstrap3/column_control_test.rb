require 'test_helper'
require 'formular/builders/bootstrap3'
require 'formular/element/bootstrap3'
require 'formular/element/bootstrap3/column_control'

describe 'Bootstrap3::ColumnControl' do
  let(:builder) { Formular::Builders::Bootstrap3.new(errors: { body: ['some nasty error'] }) }

  describe 'inline columns' do
    it 'input' do
      form = builder.form(action: '/questions/13') do |f|
        f.row do
          concat f.input(:body, label: 'Body', inline_col_class: ['col-md-6'], hint: 'some handy hint')
          concat f.input(:uuid, inline_col_class: ['col-md-2'])
          concat f.input(:public, label: 'Public', inline_col_class: ['col-md-4'])
        end
      end
      form.to_s.must_equal %(<form action="/questions/13" method="post" accept-charset=\"utf-8\"><input name=\"utf8\" type=\"hidden\" value=\"✓\"/><div class="row"><div class="col-md-6 form-group has-error"><label for="body" class="control-label">Body</label><input name="body" id="body" type="text" aria-describedby="body_hint" class="form-control"/><span id="body_hint" class="help-block">some handy hint</span><span class="help-block">some nasty error</span></div><div class="col-md-2 form-group"><input name="uuid" id="uuid" type="text" class="form-control"/></div><div class="col-md-4 form-group"><label for="public" class="control-label">Public</label><input name="public" id="public" type="text" class="form-control"/></div></div></form>)
    end

    it 'input_group' do
      form = builder.form(action: '/questions/13') do |f|
        f.row do
          concat f.input_group(:body, label: 'Body', inline_col_class: ['col-md-6'], hint: 'some handy hint')
          concat f.input_group(:uuid, inline_col_class: ['col-md-2'])
          concat f.input_group(:public, label: 'Public', inline_col_class: ['col-md-4'])
        end
      end
      form.to_s.must_equal %(<form action="/questions/13" method="post" accept-charset=\"utf-8\"><input name=\"utf8\" type=\"hidden\" value=\"✓\"/><div class="row"><div class="col-md-6 form-group has-error"><label for="body" class="control-label">Body</label><div class="input-group"><input name="body" id="body" type="text" aria-describedby="body_hint" class="form-control"/></div><span id="body_hint" class="help-block">some handy hint</span><span class="help-block">some nasty error</span></div><div class="col-md-2 form-group"><div class=\"input-group\"><input name="uuid" id="uuid" type="text" class="form-control"/></div></div><div class="col-md-4 form-group"><label for="public" class="control-label">Public</label><div class=\"input-group\"><input name="public" id="public" type="text" class="form-control"/></div></div></div></form>)
    end

    it 'select' do
      form = builder.form(action: '/questions/13') do |f|
        f.row do
          concat f.select(:body, label: 'Body', inline_col_class: ['col-md-6'], hint: 'some handy hint', collection: COLLECTION_ARRAY)
          concat f.select(:uuid, inline_col_class: ['col-md-2'], collection: COLLECTION_ARRAY)
          concat f.select(:public, label: 'Public', inline_col_class: ['col-md-4'], collection: COLLECTION_ARRAY)
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

  describe 'stacked columns' do
    it 'input' do
      form = builder.form(action: '/questions/13') do |f|
        concat f.input(:body, label: 'Body', stacked_col_class: ['col-md-6'], hint: 'some handy hint')
        concat f.input(:uuid, stacked_col_class: ['col-md-2'])
        concat f.input(:public, label: 'Public', stacked_col_class: ['col-md-4'])
      end
      form.to_s.must_equal %(<form action="/questions/13" method="post" accept-charset=\"utf-8\"><input name=\"utf8\" type=\"hidden\" value=\"✓\"/><div class="form-group has-error"><label for="body" class="control-label">Body</label><div class="row"><div class="col-md-6"><input name="body" id="body" type="text" aria-describedby="body_hint" class="form-control"/></div></div><span id="body_hint" class="help-block">some handy hint</span><span class="help-block">some nasty error</span></div><div class="form-group"><div class="row"><div class="col-md-2"><input name="uuid" id="uuid" type="text" class="form-control"/></div></div></div><div class="form-group"><label for="public" class="control-label">Public</label><div class="row"><div class="col-md-4"><input name="public" id="public" type="text" class="form-control"/></div></div></div></form>)
    end

    it 'input_group' do
      form = builder.form(action: '/questions/13') do |f|
        concat f.input_group(:body, label: 'Body', stacked_col_class: ['col-md-6'], hint: 'some handy hint')
        concat f.input_group(:uuid, stacked_col_class: ['col-md-2'])
        concat f.input_group(:public, label: 'Public', stacked_col_class: ['col-md-4'])
      end
      form.to_s.must_equal %(<form action="/questions/13" method="post" accept-charset=\"utf-8\"><input name=\"utf8\" type=\"hidden\" value=\"✓\"/><div class="form-group has-error"><label for="body" class="control-label">Body</label><div class="row"><div class="col-md-6"><div class="input-group"><input name="body" id="body" type="text" aria-describedby="body_hint" class="form-control"/></div></div></div><span id="body_hint" class="help-block">some handy hint</span><span class="help-block">some nasty error</span></div><div class="form-group"><div class="row"><div class="col-md-2"><div class=\"input-group\"><input name="uuid" id="uuid" type="text" class="form-control"/></div></div></div></div><div class="form-group"><label for="public" class="control-label">Public</label><div class="row"><div class="col-md-4"><div class=\"input-group\"><input name="public" id="public" type="text" class="form-control"/></div></div></div></div></form>)
    end

    it 'select' do
      form = builder.form(action: '/questions/13') do |f|
        concat f.select(:body, label: 'Body', stacked_col_class: ['col-md-6'], hint: 'some handy hint', collection: COLLECTION_ARRAY)
        concat f.select(:uuid, stacked_col_class: ['col-md-2'], collection: COLLECTION_ARRAY)
        concat f.select(:public, label: 'Public', stacked_col_class: ['col-md-4'], collection: COLLECTION_ARRAY)
      end
      form.to_s.must_equal %(<form action="/questions/13" method="post" accept-charset=\"utf-8\"><input name=\"utf8\" type=\"hidden\" value=\"✓\"/><div class="form-group has-error"><label for="body" class="control-label">Body</label><div class="row"><div class="col-md-6"><select name="body" id="body" aria-describedby="body_hint" class="form-control"><option value="1">Option 1</option><option value="2">Option 2</option></select></div></div><span id="body_hint" class="help-block">some handy hint</span><span class="help-block">some nasty error</span></div><div class="form-group"><div class="row"><div class="col-md-2"><select name="uuid" id="uuid" class="form-control"><option value="1">Option 1</option><option value="2">Option 2</option></select></div></div></div><div class="form-group"><label for="public" class="control-label">Public</label><div class="row"><div class="col-md-4"><select name="public" id="public" class="form-control"><option value="1">Option 1</option><option value="2">Option 2</option></select></div></div></div></form>)
    end

    it 'textarea' do
      form = builder.form(action: '/questions/13') do |f|
        concat f.textarea(:body, label: 'Body', stacked_col_class: ['col-md-6'], hint: 'some handy hint')
        concat f.textarea(:uuid, stacked_col_class: ['col-md-2'])
        concat f.textarea(:public, label: 'Public', stacked_col_class: ['col-md-4'])
      end
      form.to_s.must_equal %(<form action="/questions/13" method="post" accept-charset=\"utf-8\"><input name=\"utf8\" type=\"hidden\" value=\"✓\"/><div class="form-group has-error"><label for="body" class="control-label">Body</label><div class="row"><div class="col-md-6"><textarea name="body" id="body" aria-describedby="body_hint" class="form-control"></textarea></div></div><span id="body_hint" class="help-block">some handy hint</span><span class="help-block">some nasty error</span></div><div class="form-group"><div class="row"><div class="col-md-2"><textarea name="uuid" id="uuid" class="form-control"></textarea></div></div></div><div class="form-group"><label for="public" class="control-label">Public</label><div class="row"><div class="col-md-4"><textarea name="public" id="public" class="form-control"></textarea></div></div></div></form>)
    end
  end
end
