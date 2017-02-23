require 'test_helper'
require 'formular/builders/foundation6'

describe Formular::Builders::Foundation6 do
  let(:model) do
    Comment.new(nil, 'Something exciting', [Reply.new], Owner.new, nil, 1)
  end

  let(:builder) do
    Formular::Builders::Foundation6.new(model: model, path_prefix: :comment)
  end

  describe 'independent errors' do
    let(:builder) do
      Formular::Builders::Foundation6.new(
        errors: { body: ["This really isn't good enough!"] }
      )
    end

    it '#error should return the error element for :body' do
      element = builder.error(:body)
      element.to_s.must_equal %(<span class="form-error is-visible">This really isn&#39;t good enough!</span>)
    end
  end

  describe 'independent hints' do
    it '#error should return the error element for :body' do
      element = builder.hint(content: 'Something helpful')
      element.to_s.must_equal %(<p class="help-text">Something helpful</p>)
    end
  end
end
