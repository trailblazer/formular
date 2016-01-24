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
        # here, #group_content represents every control's content-returning method. if that method's not there,
        # it will break.
        def error(attributes, options, &block)
          attributes[:class] ||= [] # FIXME: implement in Builder as default arg.
          # attributes[:class] << "has-error"

          # div class+"has-error", form_control(..)
          html = group_content(attributes, options, &block) +
            @tag.(:span, attributes: { class: ["help-block"] }, content: options[:error])

          div({ class: ["form-group", "has-error"] }, options, html) # FIXME: redundant.
        end
      end

      module Div # :wrapper # TODO: make generic in Control.
        def div(attributes, options, content)
          return content if options[:wrapper] == false

          # TODO: test for foundation5, too!
          attributes = options[:wrapper_attrs].merge!(attributes) if options[:wrapper_attrs]

          @tag.(:div, attributes: attributes, content: content)
        end
      end

      # <div class="form-group">
      #   <label for="exampleInputEmail1">Email address</label>
      #   <input type="email" class="form-control" id="exampleInputEmail1" placeholder="Email">
      # </div>
      class Input < Formular::Builder::Input
        include ErrorWrap
        include Formular::Builder::Label

        def render(attributes, div_class:["form-group"], **options)
          html = group_content(attributes, options)
          div({ class: div_class }, options, html)
        end

      private
        def group_content(attributes, options)
          attributes[:class] ||= [] # FIXME: implement in Builder as default arg.
          attributes[:class] << "form-control"

          html = label(attributes, options)
          html << input(attributes, options) # <input>
        end

        include Div
      end

      class Textarea < Formular::Builder::Textarea
        def render(attributes, options)
          super(attributes.merge(class: ["form-control"]), options) # FIXME.
        end
        include ErrorWrap
      end

      # <div class="checkbox">
      #   <label>
      #     <input type="checkbox" value="">
      #     Option one is this and that&mdash;be sure to include why it's great
      #   </label>
      # </div>
      # TODO: add private_option :inline.

      # <label class="..-inline"><input ..>
      # <div><label class="..-inline"><input ..>
      module Checkable
        def checkable_wrap(attributes, div_class:, input_html:, inline: nil, **options)
          label_attrs = {}
          label_attrs[:class] = ["#{div_class}-inline"] if inline # e.g. checkbox-inline.

          html = @tag.(:label, attributes: label_attrs, content: "#{input_html}#{options[:label]}")

          return html if inline
          div({ class: [div_class] }, options, html) # FIXME, include Div.
        end
      end

      class Checkbox < Formular::Builder::Checkbox # do we need this?
        include Div
        include Checkable

        def render(attributes, options)
          html = checkbox(attributes, options.merge(label: false))

          checkable_wrap(attributes, options.merge(input_html: html, div_class: "checkbox"))
        end
      end
      class Radio < Formular::Builder::Radio # FIXME!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1
        include Div
        include Checkable

        def render(attributes, options)
          html = radio(attributes, options.merge(label: false))

          checkable_wrap(attributes, options.merge(input_html: html, div_class: "radio"))
        end
      end

      class Collection < Formular::Builder::Collection
      # <label>Check these out</label>
      # <input id="checkbox1" type="checkbox"><label for="checkbox1">Checkbox 1</label>
      # <input id="checkbox2" type="checkbox"><label for="checkbox2">Checkbox 2</label>
        module Render
          def render(attributes={}, options={}, html="", &block)

            html = group_content(attributes, options, &block)

            div({ class: ["form-group"] }, options, html)
          end

          def group_content(attributes, options, &block)
            @tag.(:label, attributes: {}, content: options[:label]) +
              (options[:inline] ? @tag.(:div, content: collection(attributes, options, &block)) : collection(attributes, options, &block))
          end
        end

        class Checkbox < Formular::Builder::Collection::Checkbox
          include Div

          include Render

          include ErrorWrap
        end

        class Radio < Formular::Builder::Collection::Radio
          include Div

          include Render

          include ErrorWrap
        end
      end
    end
    # TODO: TEST that attributes hash is immutuable.
  end
end
