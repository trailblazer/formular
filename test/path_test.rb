require "test_helper"
require "formular/path"

class PathTest < Minitest::Spec
  describe "#to_encoded_name" do
    it "should convert nil to empty string" do
      path = Formular::Path[nil]
      path.to_encoded_name.must_equal ""
    end

    it "should convert basic sym" do
      path = Formular::Path[:comment]
      path.to_encoded_name.must_equal %(comment)
    end
    it "should convert basic sym with name" do
      path = Formular::Path[:comment, :email]
      path.to_encoded_name.must_equal %(comment[email])
    end
    it "should convert nested sym" do
      path = Formular::Path[:comment, [:replies, 0]]
      path.to_encoded_name.must_equal %(comment[replies][])
    end
    it "should convert nested sym with name" do
      path = Formular::Path[:comment, [:replies, 0], :email]

      path.to_encoded_name.must_equal %(comment[replies][][email])
    end

    it "should convert deeply nested sym with name" do
      path = Formular::Path[:comment, [:replies, 0], [:user, 0], :email]

      path.to_encoded_name.must_equal %(comment[replies][][user][][email])
    end
  end

  describe "#to_encoded_id" do
    it "should convert basic sym" do
      path = Formular::Path[:comment]
      path.to_encoded_id.must_equal %(comment)
    end
    it "should convert basic sym with name" do
      path = Formular::Path[:comment, :email]
      path.to_encoded_id.must_equal %(comment_email)
    end
    it "should convert nested sym" do
      path = Formular::Path[:comment, [:replies, 0]]
      path.to_encoded_id.must_equal %(comment_replies_0)
    end
    it "should convert nested sym with name" do
      path = Formular::Path[:comment, [:replies, 0], :email]

      path.to_encoded_id.must_equal %(comment_replies_0_email)
    end

    it "should convert deeply nested sym with name" do
      path = Formular::Path[:comment, [:replies, 0], [:user, 0], :email]

      path.to_encoded_id.must_equal %(comment_replies_0_user_0_email)
    end
  end
end
