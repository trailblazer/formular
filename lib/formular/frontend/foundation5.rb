module Formular
  module Foundation5
    # <label class="error">Error
    #   <input type="text" class="error" />
    # </label>
    # <small class="error">Invalid entry</small>
    class Builder < Formular::Builder


      module ErrorWrap
        def error(attributes, options, tag)
          shared = { class: [:error] }

          input = super(shared.merge(attributes), options, tag )     #@element.tag(tag, {attributes: shared.merge(attributes)}.merge(content: options[:content])) # <input> or <textarea></textarea>

          @element.tag(:label, attributes: shared, content: input) +
          @element.tag(:small, attributes: shared, content: options[:error])
        end
      end

      class Input < Formular::Builder::Input # TODO: fuck inheritance.
        include ErrorWrap
      end

      class Textarea < Formular::Builder::Textarea
        include ErrorWrap
      end
    end
    # TODO: TEST that attributes hash is immutuable.
  end
end
