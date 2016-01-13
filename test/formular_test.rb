require "test_helper"

# require "reform"
# require "reform/form/dry"

class FormularTest < Minitest::Spec
  Comment = Struct.new(:id, :body, :replies, :uuid, :public, :errors) # TODO: remove errors!
  Reply   = Struct.new(:id, :errors)

  let (:model) { Comment.new(nil, nil, [Reply.new]) }

  describe "id" do
    let (:builder) { Formular::Builder.new(model: model) }

    it { builder.input(:id).must_equal %{<input name="id" type="text" value="" id="form_id" />} }
    # allow id off.
    it { builder.input(:id, id: false).must_equal %{<input name="id" type="text" value="" />} }
    # allow manual id.
    it { builder.input(:id, id: "false").must_equal %{<input name="id" type="text" value="" id="false" />} }

    it do
      builder.nested(:replies) do |f|
        f.input(:id)
      end.must_equal %{<fieldset><input name=\"replies[id]\" type=\"text\" value=\"\" id=\"form_replies_id\" /></fieldset>}
    end
  end
end
