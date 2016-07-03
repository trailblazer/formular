require 'test_helper'
require "formular/builders/foundation6"
require "formular/elements/foundation6"

#if we can test that each input renders the expected html here
#than all we need to do in the builders is test that the correct elements are included
describe Formular::Elements::Foundation6 do
  let(:builder) { Formular::Builders::Foundation6.new }
  describe Formular::Elements::Foundation6::Input do
    let(:element) { builder.input(:name, label: "Name", value: "Joseph Smith") }

    it "::attributes" do
      element.attributes.must_equal(name: "name", id: 'name', type: "text", value: "Joseph Smith")
    end

    it "#to_s" do
      element.to_s.must_equal %(<label>Name<input name="name" id="name" type="text" value="Joseph Smith"/></label>)
    end

    describe "with errors" do
      let(:element) { builder.input(:name, label: "Name", value: "Joseph Smith", error: "Something terrible happened") }

      it "#to_s" do
        element.to_s.must_equal %(<label class="is-invalid-label">Name<input name="name" id="name" type="text" class="is-invalid-input" value="Joseph Smith"/><span class="form-error is-visible">Something terrible happened</span></label>)
      end
    end

    describe "with hint" do
      let(:element) { builder.input(:name, label: "Name", value: "Joseph Smith", hint: "Something helpful") }

      it "#to_s" do
        element.to_s.must_equal %(<label>Name<input name="name" id="name" type="text" aria-describedby="name_hint" value="Joseph Smith"/><p class="help-text" id="name_hint">Something helpful</p></label>)
      end
    end
  end

  describe Formular::Elements::Foundation6::File do
    let(:element) { builder.file(:file, label: "File Upload") }

    it "::attributes" do
      element.attributes.must_equal(name: "file", id: "file", type: 'file', class: ['show-for-sr'])
    end

    it "#to_s" do
      element.to_s.must_equal %(<label for="file" class="button">File Upload</label><input name="file" id="file" type="file" class="show-for-sr"/>)
    end

    describe "with errors" do
      let(:element) { builder.file(:file, label: "File Upload", error: "Something terrible happened") }

      it "#to_s" do
        element.to_s.must_equal %(<label for="file" class="button">File Upload</label><input name="file" id="file" type="file" class="show-for-sr"/><span class="form-error is-visible">Something terrible happened</span>)
      end
    end
  end

  describe Formular::Elements::Foundation6::Checkbox do
    let(:element) { builder.checkbox(:public, value: 1, label: "Public") }

    it "::attributes" do
      element.attributes.must_equal(name: "public[]", id: "public", type: "checkbox", value: 1)
    end

    it "#to_s" do
      element.to_s.must_equal %(<fieldset><label><input name="public[]" id="public" type="checkbox" value="1"/> Public</label></fieldset>)
    end

    describe "with collection" do
      let(:element) { builder.checkbox(:public, label: "Public", collection: [[1, "Option 1"], [2, "Option 2"]]) }

      it "#to_s" do
        element.to_s.must_equal %(<fieldset><legend>Public</legend><label><input name="public[]" id="public_1" type="checkbox" value="1"/> Option 1</label><label><input name="public[]" id="public_2" type="checkbox" value="2"/> Option 2</label></fieldset>)
      end

      describe "with errors" do
        let(:element) { builder.checkbox(:public, collection: [[1, "Option 1"], [2, "Option 2"]], error: "Something terrible happened") }

        it "#to_s" do
          element.to_s.must_equal %(<fieldset><label class="is-invalid-label"><input name="public[]" id="public_1" type="checkbox" value="1"/> Option 1</label><label class="is-invalid-label"><input name="public[]" id="public_2" type="checkbox" value="2"/> Option 2</label><span class="form-error is-visible">Something terrible happened</span></fieldset>)
        end
      end
    end

    describe "with errors" do
      let(:element) { builder.checkbox(:public, value: 1, label: "Option 1", error: "Something terrible happened") }

      it "#to_s" do
        element.to_s.must_equal %(<fieldset><label class="is-invalid-label"><input name="public[]" id="public" type="checkbox" value="1"/> Option 1</label><span class="form-error is-visible">Something terrible happened</span></fieldset>)
      end
    end
  end

  describe Formular::Elements::Foundation6::Radio do
    let(:element) { builder.radio(:public, value: true, label: "Public") }

    it "::attributes" do
      element.attributes.must_equal(name: "public", id: "public", type: "radio", value: true)
    end

    it "#to_s" do
      element.to_s.must_equal %(<fieldset><label><input name="public" id="public" type="radio" value="true"/> Public</label></fieldset>)
    end

    describe "with collection" do
      let(:element) { builder.radio(:public, collection: [[1, "Option 1"], [2, "Option 2"]]) }

      it "#to_s" do
        element.to_s.must_equal %(<fieldset><label><input name="public" id="public_1" type="radio" value="1"/> Option 1</label><label><input name="public" id="public_2" type="radio" value="2"/> Option 2</label></fieldset>)
      end

      describe "with errors" do
        let(:element) { builder.radio(:public, collection: [[1, "Option 1"], [2, "Option 2"]], error: "Something terrible happened") }

        it "#to_s" do
          element.to_s.must_equal %(<fieldset><label class="is-invalid-label"><input name="public" id="public_1" type="radio" value="1"/> Option 1</label><label class="is-invalid-label"><input name="public" id="public_2" type="radio" value="2"/> Option 2</label><span class="form-error is-visible">Something terrible happened</span></fieldset>)
        end
      end
    end

    describe "with errors" do
      let(:element) { builder.radio(:public, value: 1, label: "Option 1", error: "Something terrible happened") }

      it "#to_s" do
        element.to_s.must_equal %(<fieldset><label class="is-invalid-label"><input name="public" id="public" type="radio" value="1"/> Option 1</label><span class="form-error is-visible">Something terrible happened</span></fieldset>)
      end
    end
  end

  describe Formular::Elements::Foundation6::StackedCheckbox do
    let(:element) { builder.stacked_checkbox(:public, value: 1, label: "Public") }

    it "::attributes" do
      element.attributes.must_equal(name: "public[]", id: "public", type: "checkbox", value: 1)
    end

    it "#to_s" do
      element.to_s.must_equal %(<fieldset><div><label><input name="public[]" id="public" type="checkbox" value="1"/> Public</label></div></fieldset>)
    end

    describe "with collection" do
      let(:element) { builder.stacked_checkbox(:public, collection: [[1, "Option 1"], [2, "Option 2"]]) }

      it "#to_s" do
        element.to_s.must_equal %(<fieldset><div><label><input name="public[]" id="public_1" type="checkbox" value="1"/> Option 1</label></div><div><label><input name="public[]" id="public_2" type="checkbox" value="2"/> Option 2</label></div></fieldset>)
      end

      describe "with errors" do
        let(:element) { builder.stacked_checkbox(:public, collection: [[1, "Option 1"], [2, "Option 2"]], error: "Something terrible happened") }

        it "#to_s" do
          element.to_s.must_equal %(<fieldset><div><label class="is-invalid-label"><input name="public[]" id="public_1" type="checkbox" value="1"/> Option 1</label></div><div><label class="is-invalid-label"><input name="public[]" id="public_2" type="checkbox" value="2"/> Option 2</label></div><span class="form-error is-visible">Something terrible happened</span></fieldset>)
        end
      end
    end

    describe "with errors" do
      let(:element) { builder.stacked_checkbox(:public, value: 1, label: "Option 1", error: "Something terrible happened") }

      it "#to_s" do
        element.to_s.must_equal %(<fieldset><div><label class="is-invalid-label"><input name="public[]" id="public" type="checkbox" value="1"/> Option 1</label></div><span class="form-error is-visible">Something terrible happened</span></fieldset>)
      end
    end
  end

  describe Formular::Elements::Foundation6::StackedRadio do
    let(:element) { builder.stacked_radio(:public, value: true, label: "Public") }

    it "::attributes" do
      element.attributes.must_equal(name: "public", id: "public", type: "radio", value: true)
    end

    it "#to_s" do
      element.to_s.must_equal %(<fieldset><div><label><input name="public" id="public" type="radio" value="true"/> Public</label></div></fieldset>)
    end

    describe "with collection" do
      let(:element) { builder.stacked_radio(:public, collection: [[1, "Option 1"], [2, "Option 2"]]) }

      it "#to_s" do
        element.to_s.must_equal %(<fieldset><div><label><input name="public" id="public_1" type="radio" value="1"/> Option 1</label></div><div><label><input name="public" id="public_2" type="radio" value="2"/> Option 2</label></div></fieldset>)
      end

      describe "with errors" do
        let(:element) { builder.stacked_radio(:public, collection: [[1, "Option 1"], [2, "Option 2"]], error: "Something terrible happened") }

        it "#to_s" do
          element.to_s.must_equal %(<fieldset><div><label class="is-invalid-label"><input name="public" id="public_1" type="radio" value="1"/> Option 1</label></div><div><label class="is-invalid-label"><input name="public" id="public_2" type="radio" value="2"/> Option 2</label></div><span class="form-error is-visible">Something terrible happened</span></fieldset>)
        end
      end
    end

    describe "with errors" do
      let(:element) { builder.stacked_radio(:public, value: 1, label: "Option 1", error: "Something terrible happened") }

      it "#to_s" do
        element.to_s.must_equal %(<fieldset><div><label class="is-invalid-label"><input name="public" id="public" type="radio" value="1"/> Option 1</label></div><span class="form-error is-visible">Something terrible happened</span></fieldset>)
      end
    end
  end
end