require "test_helper"

class Bootstrap3ControlTest < Minitest::Spec
  let (:model) { Comment.new(nil, nil, [Reply.new]) }
  let (:builder) { Formular::Bootstrap3::Builder.new(model: model) }

  describe "#form style: :inline" do
    it { builder.form(style: :inline){}.must_eq %{<form class="form-inline" />} }
    it { builder.form(style: :inline, class: [:bright]){}.must_eq %{<form class="form-inline bright" />} }
  end
end
