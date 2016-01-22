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

      module Div
        def div(attributes, options, content)
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
      class Checkbox < Formular::Builder::Checkbox # do we need this?
        include Div

        def render(attributes, div_class:["checkbox"], inline:nil, **options)
          html = checkbox(attributes, options.merge(label: false))

          label_attrs = {}
          label_attrs[:class] = ["checkbox-inline"] if inline

          html = @tag.(:label, attributes: label_attrs, content: "#{html}#{options[:label]}")

          return html if inline
          div({ class: div_class }, options, html)
        end
      end
      class Radio < Formular::Builder::Radio # FIXME!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1
        include Div

        def render(attributes, div_class:["radio"], **options)
          html = radio(attributes, options.merge(label: false))
          html = @tag.(:label, attributes: {}, content: "#{html}#{options[:label]}")

          div({ class: div_class }, options, html)
        end
      end

      class Collection < Formular::Builder::Collection
      # <label>Check these out</label>
      # <input id="checkbox1" type="checkbox"><label for="checkbox1">Checkbox 1</label>
      # <input id="checkbox2" type="checkbox"><label for="checkbox2">Checkbox 2</label>
        module Render
          def render(attributes={}, options={}, html="", &block)

            html = @tag.(:label, attributes: {}, content: options[:label]) +

              (options[:inline] ? @tag.(:div, content: super) : super)


            div({ class: ["form-group"] }, options, html)
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
