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
      # Wrapper (form-group div).
      # Render #group_content and wrap it via #div.
      module Render
        def render(attributes, div_class:["form-group"], **options, &block)
          html = group_content(attributes, options, &block)
          div({ class: div_class }, options, html)
        end
      end

      module ErrorWrap
        # here, #group_content represents every control's content-returning method. if that method's not there,
        # it will break.
        def error(attributes, options, &block)
          html = group_content(attributes, options, &block) +
            @tag.(:span, { class: ["help-block"] }, options[:error])

          div({ class: ["form-group", "has-error"] }, options, html) # FIXME: redundant.
        end
      end

      module Div # :wrapper # TODO: make generic in Control.
        def div(attributes, options, content)
          return content if options[:wrapper] == false

          # TODO: test for foundation5, too!
          attributes = options[:wrapper_attrs].merge!(attributes) if options[:wrapper_attrs]

          @tag.(:div, attributes, content)
        end
      end

      module Hint # :wrapper # TODO: make generic in Control.
        def hint(options)
          return "" if options[:hint] == nil || options[:hint] == false
          @tag.(:span, { class: ["help-block"] }, options[:hint])
        end
      end

      class Form < Formular::Builder::Form
        def render(attributes, options, &block)
          attributes.merge!(class: ["form-inline"]) if options[:style] == :inline
          super
        end
      end

      # <div class="form-group">
      #   <label for="exampleInputEmail1">Email address</label>
      #   <input type="email" class="form-control" id="exampleInputEmail1" placeholder="Email">
      # </div>
      class Input < Formular::Builder::Input
        include Render
        include ErrorWrap
        include Div
        include Hint

      private
        def group_content(attributes, options)
          options[:label_attrs].merge!({ class: ["control-label"] })
          attributes.merge!(class: ["form-control"])

          input = input(attributes, options) # <input>
          input = @tag.(:div, { class: ["col-sm-10"] }, input) if options[:style]==:horizontal # FRAN: this must be wrapper_attrs or something!

          html = label(attributes, options) # from Input.
          html << input
          html << hint(options)
        end
      end

      class Textarea < Formular::Builder::Textarea
        include Render
        include Div
        include ErrorWrap
        include Hint

        def group_content(attributes, options)
          options[:label_attrs].merge!({ class: ["control-label"] })
          attributes.merge!(class: ["form-control"])

          html = label(attributes, options) # from Input.
          html << textarea(attributes, options)
          html << hint(options)
        end
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

          html = @tag.(:label, label_attrs, "#{input_html}#{options[:label]}")

          return html if inline
          div({ class: [div_class] }, options, html)
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
      # <label class="control-label">Check these out</label>
      # <input id="checkbox1" type="checkbox"><label for="checkbox1">Checkbox 1</label>
      # <input id="checkbox2" type="checkbox"><label for="checkbox2">Checkbox 2</label>
        module GroupContent
          def group_content(attributes, options, &block)
            content = collection(attributes, options, &block)
            options[:label_attrs].merge!({ class: ["control-label"]})

            html = ""
            # only include the label if label option provided.
            html << @tag.(:label, options[:label_attrs], options[:label]) if options[:label]
            html << (options[:inline] ? @tag.(:div, {}, content) : content)
            html << hint(options)
          end
        end

        class Checkbox < Formular::Builder::Collection::Checkbox
          include Render
          include Div
          include Hint
          include GroupContent
          include ErrorWrap
        end

        class Radio < Formular::Builder::Collection::Radio
          include Render
          include Div
          include Hint
          include GroupContent
          include ErrorWrap
        end


      end

      class Select < Formular::Builder::Select
        include Render
        include Collection::GroupContent
        include Div
        include Hint

        def group_content(attributes, options, &block)
          attributes.merge!(class: ["form-control"])
          options[:label_attrs].merge!({ for: attributes[:id] })
          #label for option should only be included select fields, not all collections
          super
        end
      end
    end
    # TODO: TEST that attributes hash is immutuable.
  end
end
