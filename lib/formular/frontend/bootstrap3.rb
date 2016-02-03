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
          control = control(attributes, options, &block) #get the actual control html
          html = group_content(attributes, options, control) #get the group content including control
          div({ class: div_class }, options, html)
        end
      end #module Render

      module Error
        include Render
        # simply return render with the extra has-error class
        # to provide flexibility over the location of the messages themselves,
        # the messages are added inside group_content via #error_tag(options)
        def error(attributes, options, &block)
          render(attributes, div_class:["form-group", "has-error"], **options, &block)
        end

        def error_tag(options)
          return "" if (options[:error] == [] || options[:error] == nil) #options[:error] is never nil in actual forms
          @tag.(:span, { class: ["help-block"] }, options[:error])
        end
      end #module Error

      module Div # :wrapper # TODO: make generic in Control.
        def div(attributes, options, content)
          return content if options[:wrapper] == false

          # TODO: test for foundation5, too!
          attributes = options[:wrapper_attrs].merge!(attributes) if options[:wrapper_attrs]

          @tag.(:div, attributes, content)
        end
      end #module Div

      module Hint # :wrapper # TODO: make generic in Control.
        def hint(options)
          return "" if (options[:hint] == nil || options[:hint] == false)
          @tag.(:span, { class: ["help-block"] }, options[:hint])
        end
      end #module Hint

      #TODO: inject options[:style] = :horizontal to all controls
      # when form options[:style] == :horizontal
      class Form < Formular::Builder::Form
        def render(attributes, options, &block)
          attributes.merge!(class: ["form-#{options[:style]}"]) if options[:style]
          super
        end
      end #class Form

      #used to render group content regardless of actual control
      module GroupContent
        def group_content(attributes, options, control)
          column_attrs = column_attrs(options) if options[:style] == :horizontal
          options[:label_attrs].merge!({ class: ["control-label"] })

          html = label(attributes, options)
          input_html = control
          input_html << hint(options)
          input_html << error_tag(options)

          if options[:style] == :horizontal
            #used by horizontal forms to wrap the input_html in an extra wrapping div with a
            #custom class
            html << @tag.(:div, { class: column_attrs[:input_class] }, input_html)
          elsif options[:inline]
            #used by inline collections to wrap the input_html in an extra wrapping div
            html << @tag.(:div, { }, input_html)
          else
            html << input_html
          end
        end

        private
          def column_attrs(options)
            #column_attrs: { label_class: ["col-sm-2"], input_class: ["col-sm-10"]}
            #label_class is optional as if there is no label then the user will pass
            #an offset class into input_class insead
            column_attrs = options.delete(:column_attrs)
            options[:label_attrs].merge!(class: column_attrs[:label_class]) if column_attrs[:label_class]
            column_attrs
          end
      end #module GroupContent

      # <div class="form-group">
      #   <label for="exampleInputEmail1">Email address</label>
      #   <input type="email" class="form-control" id="exampleInputEmail1" placeholder="Email">
      # </div>
      class Input < Formular::Builder::Input
        include Render
        include GroupContent
        include Div
        include Hint
        include Error

      private
        def control(attributes, options, &block)
          attributes.merge!(class: ["form-control"])
          input(attributes, options)
        end
      end #class Input

      class Textarea < Formular::Builder::Textarea
        include Render
        include GroupContent
        include Div
        include Hint
        include Error

        def control(attributes, options, &block)
          attributes.merge!(class: ["form-control"])
          textarea(attributes, options)
        end
      end #class Textarea

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
      end  #module Checkable

      class Checkbox < Formular::Builder::Checkbox # do we need this?
        include Div
        include Checkable

        def render(attributes, options)
          html = checkbox(attributes, options.merge(label: false))

          checkable_wrap(attributes, options.merge(input_html: html, div_class: "checkbox"))
        end
      end #class Checkbox

      class Radio < Formular::Builder::Radio # FIXME!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1
        include Div
        include Checkable

        def render(attributes, options)
          html = radio(attributes, options.merge(label: false))

          checkable_wrap(attributes, options.merge(input_html: html, div_class: "radio"))
        end
      end #class Radio

      class Collection < Formular::Builder::Collection
      # <label class="control-label">Check these out</label>
      # <input id="checkbox1" type="checkbox"><label for="checkbox1">Checkbox 1</label>
      # <input id="checkbox2" type="checkbox"><label for="checkbox2">Checkbox 2</label>
        module Control
          def control(attributes, options, &block)
            collection(attributes, options, &block)
            #collection(attributes, options={}, html="", &block)
          end
        end

        class Checkbox < Formular::Builder::Collection::Checkbox
          include Render
          include Div
          include Hint
          include Error
          include Collection::Control
          include GroupContent

          def group_content(attributes, options, control)
            options[:label_attrs].merge!({ for: false })
            #label :for should not be included on main labels
            super
          end
        end #class Checkbox

        class Radio < Formular::Builder::Collection::Radio
          include Render
          include Div
          include Hint
          include Error
          include Collection::Control
          include GroupContent

          def group_content(attributes, options, control)
            options[:label_attrs].merge!({ for: false })
            #label :for should not be included on main labels
            super
          end
        end #class Radio
      end

      class Select < Formular::Builder::Select
        include Render
        include GroupContent
        include Collection::Control
        include Div
        include Hint
        include Error

        def control(attributes, options, &block)
          attributes.merge!(class: ["form-control"])
          super
        end
      end #class Select
    end #class Builder
    # TODO: TEST that attributes hash is immutuable.
  end #module Bootstrap3
end #module Formular
