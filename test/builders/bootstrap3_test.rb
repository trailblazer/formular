require 'test_helper'
require 'formular/builders/bootstrap3'
require 'formular/builders/bootstrap3_horizontal'
require 'formular/builders/bootstrap3_inline'

describe 'Bootstrap3 builders' do
  let(:model) { Comment.new(nil, 'Something exciting', [Reply.new], Owner.new) }
  let(:collection_array) { COLLECTION_ARRAY }
  describe Formular::Builders::Bootstrap3 do
    let(:builder) do
      Formular::Builders::Bootstrap3.new(model: model, path_prefix: :comment)
    end

    describe 'returns html correctly' do
      it '#outputs with block' do
        form = builder.form(action: '/questions/13') do |f|
          f.input(:body, label: 'Body').to_s
        end
        form.to_s.must_equal %(<form action="/questions/13" method="post" accept-charset=\"utf-8\"><input name=\"utf8\" type=\"hidden\" value=\"✓\"/><div class="form-group"><label for="comment_body" class="control-label">Body</label><input name="comment[body]" id="comment_body" value="Something exciting" type="text" class="form-control"/></div></form>)
      end

      it '#outputs without block (use end)' do
        form = builder.form(action: '/questions/13')
        html = form.start
        html << form.textarea(:body, label: 'Body').to_s
        html << form.select(
          :public,
          collection: collection_array,
          label: 'Public'
        ).to_s
        html << form.input(:body, label: 'Body').to_s
        html << form.end

        html.must_equal %(<form action="/questions/13" method="post" accept-charset=\"utf-8\"><input name=\"utf8\" type=\"hidden\" value=\"✓\"/><div class="form-group"><label for="comment_body" class="control-label">Body</label><textarea name="comment[body]" id="comment_body" class="form-control">Something exciting</textarea></div><div class="form-group"><label for=\"comment_public\" class="control-label">Public</label><select name="comment[public]" id="comment_public" class="form-control"><option value="1">Option 1</option><option value="2">Option 2</option></select></div><div class="form-group"><label for="comment_body" class="control-label">Body</label><input name="comment[body]" id="comment_body" value="Something exciting" type="text" class="form-control"/></div></form>)
      end

      it 'please ignore my labels' do
        form = builder.form(action: '/questions/13')
        html = form.start
        html << form.textarea(:body).to_s
        html << form.select(:public, collection: collection_array).to_s
        html << form.input(:body).to_s
        html << form.end

        html.must_equal %(<form action="/questions/13" method="post" accept-charset=\"utf-8\"><input name=\"utf8\" type=\"hidden\" value=\"✓\"/><div class="form-group"><textarea name="comment[body]" id="comment_body" class="form-control">Something exciting</textarea></div><div class="form-group"><select name="comment[public]" id="comment_public" class="form-control"><option value="1">Option 1</option><option value="2">Option 2</option></select></div><div class="form-group"><input name="comment[body]" id="comment_body" value="Something exciting" type="text" class="form-control"/></div></form>)
      end

      it 'please use custom labels' do
        form = builder.form(action: '/questions/13')
        html = form.start
        html << form.textarea(:body, label: 'Some fancy label').to_s
        html << form.select(
          :public,
          collection: collection_array,
          label: 'Another fancy label'
        ).to_s
        html << form.input(
          :body,
          label: 'Oh look, here\'s another fancy label'
        ).to_s
        html << form.end

        html.must_equal %(<form action="/questions/13" method="post" accept-charset=\"utf-8\"><input name=\"utf8\" type=\"hidden\" value=\"✓\"/><div class="form-group"><label for="comment_body" class="control-label">Some fancy label</label><textarea name="comment[body]" id="comment_body" class="form-control">Something exciting</textarea></div><div class="form-group"><label for=\"comment_public\" class="control-label">Another fancy label</label><select name="comment[public]" id="comment_public" class="form-control"><option value="1">Option 1</option><option value="2">Option 2</option></select></div><div class="form-group"><label for="comment_body" class="control-label">Oh look, here&#39;s another fancy label</label><input name="comment[body]" id="comment_body" value="Something exciting" type="text" class="form-control"/></div></form>)
      end
    end

    it 'file field has correct class' do
      form = builder.form(action: '/questions/13') do |f|
        f.input(:body, type: 'file', label: 'Body').to_s
      end
      form.to_s.must_equal %(<form action="/questions/13" method="post" accept-charset=\"utf-8\"><input name=\"utf8\" type=\"hidden\" value=\"✓\"/><div class="form-group"><label for="comment_body" class="control-label">Body</label><input type="file" name="comment[body]" id="comment_body" value="Something exciting"/></div></form>)
    end
  end

  describe Formular::Builders::Bootstrap3Horizontal do
    let(:builder) do
      Formular::Builders::Bootstrap3Horizontal.new(
        model: model,
        path_prefix: :comment
      )
    end

    describe 'returns html correctly' do
      it '#outputs with block' do
        form = builder.form(action: '/questions/13') do |f|
          f.input(:body, label: 'Body').to_s
        end
        form.to_s.must_equal %(<form action="/questions/13" method="post" accept-charset="utf-8" class="form-horizontal"><input name=\"utf8\" type=\"hidden\" value=\"✓\"/><div class="form-group"><label for="comment_body" class="col-sm-2 control-label">Body</label><div class="col-sm-10"><input name="comment[body]" id="comment_body" value="Something exciting" type="text" class="form-control"/></div></div></form>)
      end

      it '#outputs without block (use end)' do
        form = builder.form(action: '/questions/13')
        html = form.start
        html << form.input(:body, label: 'Body').to_s
        html << form.end

        html.must_equal %(<form action="/questions/13" method="post" accept-charset="utf-8" class="form-horizontal"><input name=\"utf8\" type=\"hidden\" value=\"✓\"/><div class="form-group"><label for="comment_body" class="col-sm-2 control-label">Body</label><div class="col-sm-10"><input name="comment[body]" id="comment_body" value="Something exciting" type="text" class="form-control"/></div></div></form>)
      end

      it 'wrapped renders correctly with hint & error' do
        form = builder.form(action: '/questions/13') do |f|
          f.input(:body, label: 'Body', hint: 'some handy hint', error: 'Something went wrong').to_s
        end

        form.to_s.must_equal %(<form action="/questions/13" method="post" accept-charset="utf-8" class="form-horizontal"><input name=\"utf8\" type=\"hidden\" value=\"✓\"/><div class="form-group has-error"><label for=\"comment_body\" class=\"col-sm-2 control-label\">Body</label><div class="col-sm-10"><input name=\"comment[body]\" id=\"comment_body\" value=\"Something exciting\" type=\"text\" aria-describedby=\"comment_body_hint\" class=\"form-control\"/><span id=\"comment_body_hint\" class=\"help-block\">some handy hint</span><span class=\"help-block\">Something went wrong</span></div></div></form>)
      end

      it 'checkbox renders correctly' do
        form = builder.form(action: '/questions/13') do |f|
          f.checkbox(:public, value: 1, label: 'Public').to_s
        end

        form.to_s.must_equal %(<form action="/questions/13" method="post" accept-charset="utf-8" class="form-horizontal"><input name=\"utf8\" type=\"hidden\" value=\"✓\"/><div class="form-group"><div class="col-sm-offset-2 col-sm-10"><input value="0" name="comment[public]" type="hidden"/><div class="checkbox"><label><input value="1" name="comment[public]" id="comment_public" type="checkbox"/> Public</label></div></div></div></form>)
      end

      it 'radio renders correctly' do
        form = builder.form(action: '/questions/13') do |f|
          f.radio(:public, value: 1, label: 'Public').to_s
        end

        form.to_s.must_equal %(<form action="/questions/13" method="post" accept-charset="utf-8" class="form-horizontal"><input name=\"utf8\" type=\"hidden\" value=\"✓\"/><div class="form-group"><div class="col-sm-offset-2 col-sm-10"><div class="radio"><label><input value="1" name="comment[public]" id="comment_public" type="radio"/> Public</label></div></div></div></form>)
      end

      it 'radio collection renders correctly' do
        form = builder.form(action: '/questions/13') do |f|
          f.radio(:public, label: 'Public', collection: collection_array).to_s
        end

        form.to_s.must_equal %(<form action="/questions/13" method="post" accept-charset="utf-8" class="form-horizontal"><input name=\"utf8\" type=\"hidden\" value=\"✓\"/><div class="form-group"><label class="col-sm-2 control-label">Public</label><div class="col-sm-10"><div class="radio"><label><input type="radio" name="comment[public]" value="1" id="comment_public_1"/> Option 1</label></div><div class="radio"><label><input type="radio" name="comment[public]" value="2" id="comment_public_2"/> Option 2</label></div></div></div></form>)
      end

      it 'inlineradio collection renders correctly' do
        form = builder.form(action: '/questions/13') do |f|
          f.inline_radio(
            :public,
            label: 'Public',
            collection: collection_array
          ).to_s
        end

        form.to_s.must_equal %(<form action="/questions/13" method="post" accept-charset="utf-8" class="form-horizontal"><input name=\"utf8\" type=\"hidden\" value=\"✓\"/><div class="form-group"><label class="col-sm-2 control-label">Public</label><div class="col-sm-10"><label class="radio-inline"><input type="radio" name="comment[public]" value="1" id="comment_public_1"/> Option 1</label><label class="radio-inline"><input type="radio" name="comment[public]" value="2" id="comment_public_2"/> Option 2</label></div></div></form>)
      end
    end
  end

  describe Formular::Builders::Bootstrap3Inline do
    let(:builder) do
      Formular::Builders::Bootstrap3Inline.new(
        model: model,
        path_prefix: :comment
      )
    end

    describe 'returns html correctly' do
      it '#outputs with block' do
        form = builder.form(action: '/questions/13') do |f|
          f.input(:body, label: 'Body').to_s
        end
        form.to_s.must_equal %(<form action="/questions/13" method="post" accept-charset="utf-8" class="form-inline"><input name=\"utf8\" type=\"hidden\" value=\"✓\"/><div class="form-group"><label for="comment_body" class="control-label">Body</label><input name="comment[body]" id="comment_body" value="Something exciting" type="text" class="form-control"/></div></form>)
      end

      it '#outputs without block (use end)' do
        form = builder.form(action: '/questions/13')
        html = form.start
        html << form.input(:body, label: 'Body').to_s
        html << form.end

        html.must_equal %(<form action="/questions/13" method="post" accept-charset="utf-8" class="form-inline"><input name=\"utf8\" type=\"hidden\" value=\"✓\"/><div class="form-group"><label for="comment_body" class="control-label">Body</label><input name="comment[body]" id="comment_body" value="Something exciting" type="text" class="form-control"/></div></form>)
      end
    end
  end
end
