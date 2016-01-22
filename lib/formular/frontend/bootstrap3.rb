module Formular
  # http://getbootstrap.com/css/#forms

  # TODO: switches, prefix actions
  module Bootstrap3
    #  <div class="form-group has-error">
    #   <label class="control-label" for="inputerror1">Input with success</label>
    #   <input type="text" class="form-control" id="inputSuccess1" aria-describedby="helpBlock2">
    #   <span id="helpBlock2" class="help-block">A block of help text that breaks onto a new line and may extend beyond one line.</span>
    # </div>
    class Builder < Formular::Builder
      module ErrorWrap
        def error(attributes, options, &block)
          attributes[:class] ||= [] # FIXME: implement in Builder as default arg.
          # attributes[:class] << "has-error"

          # div class+"has-error", form_control(..)
          html = group_content(attributes, options) +
            @tag.(:span, attributes: { class: ["help-block"] }, content: options[:error])

          div({ class: ["form-group", "has-error"] }, options, html) # FIXME: redundant.
        end
      end

      # <div class="form-group">
      #   <label for="exampleInputEmail1">Email address</label>
      #   <input type="email" class="form-control" id="exampleInputEmail1" placeholder="Email">
      # </div>
      class Input < Formular::Builder::Input
        include ErrorWrap
        include Formular::Builder::Label

        def render(attributes, options)
          html = group_content(attributes, options)
          div({ class: ["form-group"] }, options, html)
        end

      private
        def group_content(attributes, options)
          attributes[:class] ||= [] # FIXME: implement in Builder as default arg.
          attributes[:class] << "form-control"

          html = label(attributes, options)
          html << input(attributes, options) # <input>
        end

        def div(attributes, options, content)
          @tag.(:div, attributes: attributes, content: content)
        end
      end

      class Textarea < Formular::Builder::Textarea
        include ErrorWrap
      end

      # <input id="checkbox1" type="checkbox"><label for="checkbox1">Checkbox 1</label>
      class Checkbox < Formular::Builder::Checkbox
      end

      class Collection < Formular::Builder::Collection
      # <label>Check these out</label>
      # <input id="checkbox1" type="checkbox"><label for="checkbox1">Checkbox 1</label>
      # <input id="checkbox2" type="checkbox"><label for="checkbox2">Checkbox 2</label>
        class Checkbox < Formular::Builder::Collection::Checkbox
          def render(attributes={}, options={}, html="", &block)
            @tag.(:label, attributes: {}, content: options[:label]) +  # TODO: allow attributes.
              super
          end

          include ErrorWrap
        end

        class Radio < Checkbox
        end
      end
    end
    # TODO: TEST that attributes hash is immutuable.
  end
end
