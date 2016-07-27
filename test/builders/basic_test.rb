require 'test_helper'
require 'formular/builders/basic'
require 'formular/builders/bootstrap3'

describe Formular::Builders::Basic do
  let(:model) { Comment.new(nil, 'Something exciting', [Reply.new], Owner.new, nil, 1) }
  let(:builder) { Formular::Builders::Basic.new(model: model) }

  describe '#nested' do
    it 'with singular' do
      builder.nested(:owner) do |o|
        o.input :id
      end.to_s.must_equal %(<input name=\"owner[id]\" id=\"owner_id\" type=\"text\"/>)
    end

    it 'with custom builder' do
      builder.nested(:owner, builder: Formular::Builders::Bootstrap3) do |o|
        o.input :id
      end.to_s.must_equal %(<div class="form-group"><input name=\"owner[id]\" id=\"owner_id\" type=\"text\" class="form-control"/></div>)
    end
  end

  describe '#collection' do
    it 'infer collection from name' do
      builder.collection(:replies) do |o|
        o.input :id
      end.to_s.must_equal %(<input name=\"replies[][id]\" id=\"replies_0_id\" type=\"text\"/>)
    end

    it 'form and collection' do
      model = OpenStruct.new(ble: 'blargh', coll: [OpenStruct.new(name: 1, id: 3), OpenStruct.new(name: 2, id: 5)])

      f = Formular::Builders::Basic.new(model: model, path_prefix: 'blah' ).form(method: :post, action: '/ok') do |f|
        concat f.input :ble
        concat f.collection(:coll) { |g|
          concat g.input :name
          concat g.input :id
        }
      end

      f.to_s.must_equal %(<form method="post" action="/ok" accept-charset="utf-8"><input name="utf8" type="hidden" value="✓"/><input name="blah[ble]" id="blah_ble" value="blargh" type="text"/><input name="blah[coll][][name]" id="blah_coll_0_name" value="1" type="text"/><input name="blah[coll][][id]" id="blah_coll_0_id" value="3" type="text"/><input name="blah[coll][][name]" id="blah_coll_1_name" value="2" type="text"/><input name="blah[coll][][id]" id="blah_coll_1_id" value="5" type="text"/></form>)
    end

    it 'custom builder' do
      builder.collection(:replies, builder: Formular::Builders::Bootstrap3) do |o|
        o.input :id
      end.to_s.must_equal %(<div class="form-group"><input name=\"replies[][id]\" id=\"replies_0_id\" type=\"text\" class="form-control"/></div>)
    end
  end
end
