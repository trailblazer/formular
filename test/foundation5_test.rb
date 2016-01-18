require "test_helper"
require "cells-slim"
require "cells-hamlit"

require "formular/frontend/foundation5"

require "reform"
require "reform/form/dry"



module F5
  class Form < Reform::Form
    include Dry::Validations

    property :id
    property :uuid
    property :body

    validation :default do
      key(:uuid) { |uuid| uuid.filled? }
      key(:body) { |body| body.max_size?(10) }
    end

    collection :replies do
      property :email
    end
  end
end



class Comment::NewCell < Cell::ViewModel
  include Cell::Slim
  # include Cell::Hamlit

  self.view_paths = ['test/fixtures']

  def show
    render
  end

  def form(model:nil, **options, &block)
    Formular::Foundation5::Builder.new(model: model).form(options, &block)
  end
end

#@template=#<Erbse::Template:0x9aa53f8 @src="
# @output_buffer = output_buffer;
# @output_buffer.safe_append='New\n\n'.freeze;
# @output_buffer.append=  form model do |f|
# @output_buffer.safe_append='\n  ID for '.freeze;@output_buffer.append=( model.class );@output_buffer.safe_append=': '.freeze;@output_buffer.append=( f.input :id );@output_buffer.safe_append='\n'.freeze;   #raise \n end \n@output_buffer.safe_append='\n'.freeze; inner = capture do \n@output_buffer.safe_append='\n  '.freeze;@output_buffer.append=( self.class );@output_buffer.safe_append='\n'.freeze; end \n@output_buffer.to_s

class Cell::ViewModel
  module Capture
    # Only works with Slim, so far.
    def capture(*args)
      yield(*args)
    end
  end
end


class Form < Cell::ViewModel
  include Cell::Slim
  # include Cell::Hamlit
end

class Foundation5Test < Minitest::Spec
  let (:model) { Comment.new(nil, nil, [Reply.new]) }
  let (:builder) { Formular::Foundation5::Builder.new(model: model) }

  describe "#input" do
    it { builder.input(:id, label: "Id").must_equal %{<label >Id<input name="id" type="text" id="form_id" value="" /></label>} }
    it { builder.input(:id).must_equal                        %{<input name="id" type="text" id="form_id" value="" />} }

    describe "with errors" do
      let (:model) { Comment.new(nil, nil, [Reply.new], nil, nil, {id: ["wrong!"]}) }

      it { builder.input(:id).must_equal %{<input class="error" name="id" type="text" id="form_id" value="" /><small class="error">["wrong!"]</small>} }
      it { builder.input(:id, label: "Id").must_equal %{<label >Id<input class="error" name="id" type="text" id="form_id" value="" /></label><small class="error">["wrong!"]</small>} }
    end
  end

  describe "#checkbox" do
    describe "unchecked" do
      it { builder.checkbox(:public, label: "Public?").must_equal %{<input type="hidden" value="0" name="public" /><input name="public" type="checkbox" id="form_public_1" value="1" /><label for="form_public_1">Public?</label>} }
      it { builder.checkbox(:public).must_equal %{<input type="hidden" value="0" name="public" /><input name="public" type="checkbox" id="form_public_1" value="1" />} }
    end

    describe "with errors" do

    end
  end

  describe "#checkbox_collection" do
    it do
      # TODO: allow merging :class!
      builder.collection(:public, [[:One, 1],[:Two, 2],[:Three, 3]], checkbox: true, checked: [2,3], label: "One!").must_equal %{
<label >One!</label>
<input name=\"public[]\" type=\"checkbox\" value=\"1\" id=\"form_public_1\" /><label for=\"form_public_1\">One</label>
<input name=\"public[]\" type=\"checkbox\" value=\"2\" checked=\"true\" id=\"form_public_2\" /><label for=\"form_public_2\">Two</label>
<input type=\"hidden\" value=\"0\" name=\"public[]\" />
<input name=\"public[]\" type=\"checkbox\" value=\"3\" checked=\"true\" id=\"form_public_3\" /><label for=\"form_public_3\">Three</label>}.gsub("\n", "")
    end

    describe "with errors" do
      let (:model) { Comment.new(nil, nil, [], nil, nil, {public: ["wrong!"]}) }

      it do
        builder.collection(:public, [[:One, 1],[:Two, 2],[:Three, 3]], checkbox: true, checked: [2,3], label: "One!").must_equal %{
<label >One!</label>
<input name="public[]" type="checkbox" value="1" id="form_public_1" /><label for="form_public_1">One</label>
<input name="public[]" type="checkbox" value="2" checked="true" id="form_public_2" /><label for="form_public_2">Two</label>
<input type="hidden" value="0" name="public[]" />
<input name="public[]" type="checkbox" value="3" checked="true" id="form_public_3" /><label for="form_public_3">Three</label>
<small class="error">["wrong!"]</small>
}.gsub("\n", "")
      end
    end
  end

#   it do
#     # TODO: allow merging :class!
#     builder.collection(:public, [[:One, 1],[:Two, 2],[:Three, 3]], checkbox: true, checked: [2,3]) do |model:, options:, index:, **|
#       builder.checkbox(:public, options.merge(label: false, class: [(index.even? ? :even : :odd)])) +
#         builder.label(model.first, for: options[:id], "data-action": :create)

#     end.must_equal %{
# <input name="public[]" type="checkbox" value="1" class="even" id="form_public_1" /><label content="One" for="form_public_1" data-action="create" />
# <input name="public[]" type="checkbox" value="2" checked="true" class="odd" id="form_public_2" /><label content="Two" for="form_public_2" data-action="create" />
# <input type="hidden" value="0" name="public[]" />
# <input name="public[]" type="checkbox" value="3" checked="true" class="even" id="form_public_3" /><label content="Three" for="form_public_3" data-action="create" />}.gsub("\n", "")
#     end
#   end
end

class Foundation6Test < Minitest::Spec
  describe "valid, initial rendering" do
    let (:model) { Comment.new(1, "Nice!", [Reply.new]) }

    it { Comment::NewCell.new(model).().must_equal %{<New></New>
<form action="/posts">ID
<input name="id" type="text" id="form_id" value="1" />
<textarea name="body" id="form_body">Nice!</textarea>
<fieldset ><input name="replies[email]" type="text" id="form_replies_0_email" value="" /></fieldset>
<input type="button" value="Submit" /><input name="uuid" type="text" value="0x" id="form_uuid" />
</form>}.gsub("\n", "") }
  end


  describe "with errors" do
    let (:model) do
      F5::Form.new(Comment.new(nil, "hang ten in east berlin", []))
    end

    before { model.validate({}) }

    it do
      Comment::NewCell.new(model).().must_equal %{<New></New><form action="/posts">ID
<input name="id" type="text" id="form_id" value="" />
<textarea class="error" name="body" id="form_body">
hang ten in east berlin
</textarea>
<small class="error">["body size cannot be greater than 10"]</small>
<input type="button" value="Submit" />
<input class="error" name="uuid" type="text" value="0x" id="form_uuid" /><small class="error">["uuid must be filled"]</small>
</form>}.gsub("\n", "")
    end
  end
end
