require "test_helper"

class Bootstrap3ControlTest < Minitest::Spec
  let (:model) { Comment.new(nil, nil, [Reply.new]) }
  let (:builder) { Formular::Bootstrap3::Builder.new(model: model) }

  describe "#form style: :inline" do
    it { builder.form(style: :inline){}.must_eq %{<form class="form-inline" />} }
    it { builder.form(style: :inline, class: [:bright]){}.must_eq %{<form class="form-inline bright" />} }

  end

    # with label_attrs. Horizontal tests are all in seperate class
#     it { builder.input(:id, label: "ID", style: :horizontal,
#       label_attrs: { class: ["col-sm-2"] }).must_eq %{
# <div class="form-group">
# <label class="control-label col-sm-2" for="form_id">ID</label>
# <div class="col-sm-10"><input type="text" name="id" id="form_id" class="form-control" value="" /></div>
# </div>} }
end
