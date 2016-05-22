require "formular/elements/input"
require "formular/elements/textarea"
require "formular/elements/container"
require "formular/elements/label"
require "formular/elements/control_group"
module Formular
  module Elements
    module Bootstrap3
      class Input < Formular::Elements::Input
        attribute :class, ["form-control"]

        html do |input|
          control_html = opening_tag(true)
          wrapper_attrs = {class: ["has-error"]} if input.has_errors?
          input.builder.wrapper(wrapper_attrs) do
            concat input.label
            concat control_html
            concat input.error
          end.to_s
        end

        include Formular::Elements::ControlGroup
      end #class Input

      class Error < Formular::Elements::Container
        tag :span
        attribute :class, ["help-block"]

      end

      class File < Formular::Elements::Bootstrap3::Input
        attribute :class, []
        attribute :type, "file"

        include Formular::Elements::ControlGroup
      end #class File

      class Textarea < Formular::Elements::Textarea
        attribute :class, ["form-control"]

        html do |input|
          wrapper_attrs = {class: ["has-error"]} if input.has_errors?
          control_html = [opening_tag(true),input.content,closing_tag].join("")
          input.builder.wrapper(input.wrapper_attrs) do
            concat input.label
            concat control_html
            concat input.error
          end
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
        attribute :class, ["btn", "btn-primary"]
      end
    end #module Bootstrap 3
  end #module Elements
end #module Formular
