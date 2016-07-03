require "test_helper"
require "formular/builders/basic"

describe Formular::Builders::Basic do
  let(:model) { Comment.new(nil, "Something exciting", [Reply.new], Owner.new, nil, 1) }
  let(:builder) { Formular::Builders::Basic.new(model: model) }

  describe "#nested" do
    it "with singular" do
      builder.nested(:owner) do |o|
        o.input :id
      end.to_s.must_equal %{<input name=\"owner[id]\" id=\"owner_id\" type=\"text\"/>}
    end
  end

  describe "#collection" do
    it "with collection" do
      builder.collection(:replies) do |o|
        o.input :id
      end.to_s.must_equal %{<input name=\"replies[][id]\" id=\"replies_0_id\" type=\"text\"/>}
    end
  end
end
