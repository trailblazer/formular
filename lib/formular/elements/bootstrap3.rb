require "formular/elements/input"
require "formular/elements/textarea"
require "formular/elements/container"
require "formular/elements/label"
require "formular/elements/control_group"
require "formular/elements/select"
module Formular
  module Elements
    module Bootstrap3
      module ControlHtml
        def html_block
          Proc.new() do |input|
            input.builder.wrapper(input.has_errors? ? {class: ["has-error"]} : {}) do
              concat input.label
              concat input.control_html
              concat input.error
            end.to_s
          end
        end
      end #module ControlHtml

      class Error < Formular::Elements::Container
        tag :span
        attribute :class, ["help-block"]

      end #class Error

      class Input < Formular::Elements::Input
        extend Formular::Elements::Bootstrap3::ControlHtml

        attribute :class, ["form-control"]

        html &html_block

        def control_html
          Renderer.new(Proc.new {opening_tag(true)}).call(self)
        end
        include Formular::Elements::ControlGroup
      end #class Input

      class Select < Formular::Elements::Select
        extend Formular::Elements::Bootstrap3::ControlHtml

        attribute :class, ["form-control"]

        html &html_block

        def control_html
          Renderer.new(Proc.new { |input| [opening_tag,input.option_tags,closing_tag].join("") }).call(self)
        end

        include Formular::Elements::ControlGroup
      end #class Select

      class File < Formular::Elements::Bootstrap3::Input
        extend Formular::Elements::Bootstrap3::ControlHtml
        attribute :class, []
        attribute :type, "file"

        html &html_block

        include Formular::Elements::ControlGroup
      end #class File

      class Textarea < Formular::Elements::Textarea
        extend Formular::Elements::Bootstrap3::ControlHtml

        attribute :class, ["form-control"]

        html &html_block

        def control_html
          Renderer.new(Proc.new { |input| [opening_tag,input.content,closing_tag].join("") }).call(self)
        end
        include Formular::Elements::ControlGroup
      end #class Textarea

      class Label < Formular::Elements::Label
        attribute :class, ["control-label"]
      end #class Label

      class Wrapper < Formular::Elements::Container
        tag "div"
        attribute :class, ["form-group"]
      end #class Wrapper

      class Submit < Formular::Elements::Submit
        attribute :class, ["btn", "btn-default"]
      end #class Submit
    end #module Bootstrap3
  end #module Elements
end #module Formular
