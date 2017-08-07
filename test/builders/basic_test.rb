require 'test_helper'
require 'formular/builders/basic'
require 'formular/builders/bootstrap3'

describe Formular::Builders::Basic do
  let(:model) { Comment.new(nil, 'Something exciting', [Reply.new], Owner.new, nil, 1) }
  let(:builder) { Formular::Builders::Basic.new(model: model) }

  describe "correctly determines value" do
    it "calls reader value" do
      builder.input(:body).to_s.must_equal %(<input name="body" id="body" value="Something exciting" type="text"/>)
    end

    it "value option overrides reader when not nil" do
      builder.input(:body, value: 'Something else').to_s.must_equal %(<input value="Something else" name="body" id="body" type="text"/>)
    end

    it "value option overrides reader when nil" do
      builder.input(:body, value: nil).to_s.must_equal %(<input value="" name="body" id="body" type="text"/>)
    end
  end

  describe '#nested' do
    it 'with singular' do
      builder.nested(:owner) do |o|
        o.input :id
      end.to_s.must_equal %(<input name="owner[id]" id="owner_id" type="text"/>)
    end

    it 'with custom builder' do
      builder.nested(:owner, builder: Formular::Builders::Bootstrap3) do |o|
        o.input :id
      end.to_s.must_equal %(<div class="form-group"><input name="owner[id]" id="owner_id" type="text" class="form-control"/></div>)
    end
  end

  describe '#collection' do
    it 'infer collection from name' do
      builder.collection(:replies) do |o|
        o.input :id
      end.to_s.must_equal %(<input name="replies[][id]" id="replies_0_id" type="text"/>)
    end

    it 'provide collection' do
      builder.collection(:replies, models: [Reply.new, Reply.new]) do |o|
        o.input :id
      end.to_s.must_equal %(<input name="replies[][id]" id="replies_0_id" type="text"/><input name=\"replies[][id]\" id=\"replies_1_id\" type=\"text\"/>)
    end

    it 'custom builder' do
      builder.collection(:replies, builder: Formular::Builders::Bootstrap3) do |o|
        o.input :id
      end.to_s.must_equal %(<div class="form-group"><input name="replies[][id]" id="replies_0_id" type="text" class="form-control"/></div>)
    end
  end
end
