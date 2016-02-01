require "test_helper"
require "formular/frontend/bootstrap3"

class Bootstrap3Test < Minitest::Spec
  let (:model) { Comment.new(nil, nil, [Reply.new]) }
  let (:builder) { Formular::Bootstrap3::Builder.new(model: model) }

  describe "#input" do
    # with label.
    it { builder.input(:id, label: "Id").must_eq %{
<div class="form-group">
<label class="control-label" for="form_id">Id</label>
<input type="text" name="id" id="form_id" class="form-control" value="" />
</div>} }

    # with hint
    it { builder.input(:id, hint: "Handy help text").must_eq %{
<div class="form-group">
<input type="text" name="id" id="form_id" class="form-control" value="" />
<span class="help-block">Handy help text</span>
</div>} }
    
    # no options.
    it { builder.input(:id).must_eq %{
<div class="form-group">
<input type="text" name="id" id="form_id" class="form-control" value="" />
</div>} }

    describe "attributes for input" do
      it do
        builder.input(:id, "remote-data": true, class: [:element]).must_eq %{<div class="form-group">
<input type="text" remote-data="true" class="form-control element" name="id" id="form_id" value="" />
</div>}
      end
    end

    describe "wrapper_attrs: {}" do
      it do
        builder.input(:id, wrapper_attrs: { "remote-data": true }).must_eq %{<div remote-data="true" class="form-group"><input type="text" name="id" id="form_id" class="form-control" value="" /></div>}
      end

      it do
        builder.input(:id, wrapper_attrs: { class: [:bright] }).must_eq %{<div class="form-group bright"><input type="text" name="id" id="form_id" class="form-control" value="" /></div>}
      end

      it do
        builder.input(:id, wrapper_attrs: { class: [:bright], "remote-data": true }).must_eq %{<div class="form-group bright" remote-data="true"><input type="text" name="id" id="form_id" class="form-control" value="" /></div>}
      end

      # with errors
      it do
        builder.input(:id, wrapper_attrs: { class: [:bright], "remote-data": true }, error: ["wrong@!"]).must_eq %{
<div class="form-group has-error bright" remote-data="true">
<input type="text" name="id" id="form_id" class="form-control" value="" /><span class="help-block">["wrong@!"]</span></div>
}
      end
      # with hint
      it do
        builder.input(:id, wrapper_attrs: { class: [:bright], "remote-data": true }, hint: "Handy help text").must_eq %{<div class="form-group bright" remote-data="true"><input type="text" name="id" id="form_id" class="form-control" value="" /><span class="help-block">Handy help text</span></div>}
      end
    end

    describe "label_attrs: {}" do
      it "ignores without :label" do
        builder.input(:id, label_attrs: { "remote-data": true }).must_eq %{
<div class="form-group"><input type="text" name="id" id="form_id" class="form-control" value="" /></div>}
      end

      it do
        builder.input(:id, label_attrs: { "remote-data": true, class: [:id] }, label: "Id").must_eq %{
<div class="form-group"><label remote-data="true" class="control-label id" for="form_id">Id</label>
<input type="text" name="id" id="form_id" class="form-control" value="" /></div>}
      end

      # with errors
      it do
        builder.input(:id, label_attrs: { "remote-data": true, class: [:id] }, label: "Id", error: ["wrong@!"]).must_eq %{
<div class="form-group has-error"><label remote-data="true" class="control-label id" for="form_id">Id</label>
<input type="text" name="id" id="form_id" class="form-control" value="" />
<span class="help-block">["wrong@!"]</span>
</div>}
      end
    end

    describe "with errors" do
      let (:model) { Comment.new(nil, nil, [Reply.new], nil, nil, {id: ["wrong!"]}) }

      it { builder.input(:id).must_eq %{
<div class="form-group has-error">
<input type="text" name="id" id="form_id" class="form-control" value="" />
<span class="help-block">[\"wrong!\"]</span>
</div>} }

      describe "with label" do
        it do 
          builder.input(:id, label: "Id").must_eq %{
<div class="form-group has-error">
<label class="control-label" for="form_id">Id</label>
<input type="text" name="id" id="form_id" class="form-control" value="" />
<span class="help-block">[\"wrong!\"]</span>
</div>} 
        end
      end
      
      describe "with hint" do
        it do 
          builder.input(:id, hint: "Handy help text").must_eq %{
<div class="form-group has-error">
<input type="text" name="id" id="form_id" class="form-control" value="" />
<span class="help-block">Handy help text</span>
<span class="help-block">[\"wrong!\"]</span>
</div>}
        end
      end
    end

    describe "wrapper: false" do
      it "with label" do
         builder.input(:id, label: "Id", wrapper: false).must_eq %{
<label class="control-label" for="form_id">Id</label>
<input type="text" name="id" id="form_id" class="form-control" value="" />}
      end

      it "without label" do
        builder.input(:id, wrapper: false).must_eq %{
<input type="text" name="id" id="form_id" class="form-control" value="" />}
      end


      it "with label & has error" do 
        builder.input(:id, label: "Id", wrapper: false, error: ["wrong!"]).must_eq %{
<label class="control-label" for="form_id">Id</label>
<input type="text" name="id" id="form_id" class="form-control" value="" />
<span class="help-block">[\"wrong!\"]</span>}
      end
          
      it "with hint" do
         builder.input(:id, hint: 'Handy help text', wrapper: false).must_eq %{
<input type="text" name="id" id="form_id" class="form-control" value="" />
<span class="help-block">Handy help text</span>}
      end
    end
  end

  describe "#textarea" do
    it "wrapper: false" do
      builder.textarea(:public, rows: 3, wrapper: false).must_eq %{<textarea rows="3" name="public" id="form_public" class="form-control"></textarea>}
    end
    
    it do
      builder.textarea(:public, rows: 3).must_eq %{
<div class="form-group">
<textarea rows="3" name="public" id="form_public" class="form-control"></textarea>
</div>}
    end
    
    it "with label" do
      builder.textarea(:public, rows: 3, label: "Public").must_eq %{
<div class="form-group">
<label class="control-label" for="form_public">Public</label>
<textarea rows="3" name="public" id="form_public" class="form-control"></textarea>
</div>}
    end

    it "with errors" do
      builder.textarea(:public, rows: 3, error: ["wrong!"]).must_eq %{
<div class="form-group has-error"><textarea rows="3" name="public" id="form_public" class="form-control"></textarea><span class="help-block">["wrong!"]</span></div>
}
    end
  end

  describe "#checkbox" do
    describe "stacked (default)" do
      it { builder.checkbox(:public, label: "Public?").must_eq %{
<div class="checkbox">
<label >
<input type="hidden" value="0" name="public" />
<input type="checkbox" name="public" id="form_public_1" value="1" />
Public?
</label>
</div>
}
      }

      # TODO: more classes
      # <div class="checkbox disabled">
      #   <label>
      #     <input type="checkbox" value="" disabled>
      #     Option two is disabled
      #   </label>
      # </div>
    end



    # describe "unchecked" do
    #   it { builder.checkbox(:public, label: "Public?").must_equal %{<input type="hidden" value="0" name="public" /><input name="public" type="checkbox" id="form_public_1" value="1" /><label for="form_public_1">Public?</label>} }
    #   it { builder.checkbox(:public).must_equal %{<input type="hidden" value="0" name="public" /><input name="public" type="checkbox" id="form_public_1" value="1" />} }
    # end

    # DISCUSS: is that correct, the span after the div?
    describe "with errors" do
      it { builder.checkbox(:public, label: "Public?", error: ["wrong!"]).must_eq %{
<div class="checkbox">
<label >
<input type="hidden" value="0" name="public" />
<input type="checkbox" name="public" id="form_public_1" value="1" />
Public?
</label>
</div>
<span class="error">["wrong!"]</span>
}
      }
    end

    describe "inline: true" do
      it { builder.checkbox(:public, label: "Public?", inline: true).must_eq %{
<label class="checkbox-inline">
<input type="hidden" value="0" name="public" />
<input type="checkbox" name="public" id="form_public_1" value="1" />
Public?
</label>
}
      }

      # TODO: more classes
      # <div class="checkbox disabled">
      #   <label>
      #     <input type="checkbox" value="" disabled>
      #     Option two is disabled
      #   </label>
      # </div>
    end
  end



  describe "#radio" do
    describe "stacked (default)" do
      it { builder.radio(:public, label: "Public?", value: 1).must_eq %{
<div class="radio">
<label >
<input type="radio" value="1" name="public" id="form_public_1" />
Public?
</label>
</div>
}
      }
    end

    describe "inline: true" do
      it { builder.radio(:public, label: "Public?", value: 1, inline: true).must_eq %{
<label class="radio-inline">
<input type="radio" value="1" name="public" id="form_public_1" />
Public?
</label>
} }
    end

    describe "with errors" do

    end

    describe "wrapper: false" do

    end
  end


  describe "collection type: :checkbox" do
    it do
      # TODO: allow merging :class!
      builder.collection(:public, [[:One, 1],[:Two, 2],[:Three, 3]], type: :checkbox, checked: [2,3], label: "One!").must_eq %{
<div class="form-group">
<label class="control-label">One!</label>
<div class="checkbox"><label ><input type="checkbox" value="1" name="public[]" id="form_public_1" />One</label></div>
<div class="checkbox"><label ><input type="checkbox" value="2" checked="true" name="public[]" id="form_public_2" />Two</label></div>
<div class="checkbox">
<label ><input type="hidden" value="0" name="public[]" />
<input type="checkbox" value="3" checked="true" name="public[]" id="form_public_3" />Three</label>
</div>
</div>
}
    end

    describe "with errors" do
      let (:model) { Comment.new(nil, nil, [], nil, nil, {public: ["wrong!"]}) }

      it do
        builder.collection(:public, [[:One, 1],[:Two, 2],[:Three, 3]], type: :checkbox, checked: [2,3], label: "One!").must_eq %{
<div class="form-group has-error">
<label class="control-label">One!</label>
<div class="checkbox"><label ><input type="checkbox" value="1" name="public[]" id="form_public_1" />One</label></div>
<div class="checkbox"><label ><input type="checkbox" value="2" checked="true" name="public[]" id="form_public_2" />Two</label></div>
<div class="checkbox">
<label ><input type="hidden" value="0" name="public[]" />
<input type="checkbox" value="3" checked="true" name="public[]" id="form_public_3" />Three</label>
</div>
<span class="help-block">[\"wrong!\"]</span>
</div>
}
      end
    end

    it "inline: true" do
      # TODO: allow merging :class!
      builder.collection(:public, [[:One, 1],[:Two, 2],[:Three, 3]], type: :checkbox, checked: [2,3], label: "One!", inline: true).must_eq %{
<div class="form-group">
<label class="control-label">One!</label><div ><label class="checkbox-inline"><input type="checkbox" value="1" name="public[]" id="form_public_1" />One</label>
<label class="checkbox-inline"><input type="checkbox" value="2" checked="true" name="public[]" id="form_public_2" />Two</label>
<label class="checkbox-inline"><input type="hidden" value="0" name="public[]" />
<input type="checkbox" value="3" checked="true" name="public[]" id="form_public_3" />Three</label></div></div>
}
    end
  end

  describe "collection type: :radio" do
    it do
      # TODO: allow merging :class!
      builder.collection(:public, [[:One, 1],[:Two, 2],[:Three, 3]], type: :radio, checked: [2,3], label: "One!").must_eq %{
<div class="form-group">
<label class="control-label">One!</label>
<div class="radio"><label ><input type="radio" value="1" name="public" id="form_public_1" />One</label></div>
<div class="radio"><label ><input type="radio" value="2" checked="true" name="public" id="form_public_2" />Two</label></div>
<div class="radio"><label ><input type="radio" value="3" checked="true" name="public" id="form_public_3" />Three</label></div>
</div>
}
    end

    it "inline: true" do
      # TODO: allow merging :class!
      builder.collection(:public, [[:One, 1],[:Two, 2],[:Three, 3]], type: :radio, checked: [2,3], label: "One!", inline: true).must_eq %{
<div class="form-group">
<label class="control-label">One!</label>
<div >
<label class="radio-inline"><input type="radio" value="1" name="public" id="form_public_1" />One</label>
<label class="radio-inline"><input type="radio" value="2" checked="true" name="public" id="form_public_2" />Two</label>
<label class="radio-inline"><input type="radio" value="3" checked="true" name="public" id="form_public_3" />Three</label>
</div>
</div>
}
    end

#     describe "with errors" do
#     end
  end

  describe "collection type: :select" do
    describe "without label" do
      it do
        builder.collection(:public, [[:One, 1],[:Two, 2],[:Three, 3]], selected: [2], type: :select).must_eq %{
<div class="form-group">
<select name="public" id="form_public" class="form-control">
<option value="1">One</option>
<option value="2" selected="true">Two</option>
<option value="3">Three</option>
</select>
</div>}
      end
      it "with hint" do
        builder.collection(:public, [[:One, 1],[:Two, 2],[:Three, 3]], selected: [2], type: :select, hint: "Handy help text").must_eq %{
<div class="form-group">
<select name="public" id="form_public" class="form-control">
<option value="1">One</option>
<option value="2" selected="true">Two</option>
<option value="3">Three</option>
</select>
<span class="help-block">Handy help text</span>
</div>}
      end
    end
    
    it do
      builder.collection(:public, [[:One, 1],[:Two, 2],[:Three, 3]], selected: [2], label: "One!", type: :select).must_eq %{
<div class="form-group">
<label for="form_public" class="control-label">One!</label>
<select name="public" id="form_public" class="form-control">
<option value="1">One</option>
<option value="2" selected="true">Two</option>
<option value="3">Three</option>
</select>
</div>
}
    end

    describe "wrapper_attrs: {}" do
      it do
        builder.collection(:public, [[:Two, 2]], selected: [2], label: "One!", type: :select,
          wrapper_attrs: { class: ["bright"], "data-remote": true },

          class: [:shiny],
          "data-select": true, # input_attrs
          ).must_eq %{
<div class="form-group bright" data-remote="true">
<label for="form_public" class="control-label">One!</label>
<select class="form-control shiny" data-select="true" name="public" id="form_public">
<option value="2" selected="true">Two</option>
</select>
</div>}
      end
    end
  end
end
