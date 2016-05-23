require "formular/element"
require "formular/elements"
require "formular/elements/modules/container"
require "formular/elements/modules/wrapped_control"
require "formular/elements/module"
module Formular
  module Elements
    module Bootstrap3
      class Error < Formular::Element
        include Formular::Elements::Modules::Container
        tag :span
        attribute :class, ["help-block"]

      end #class Error

      class Input < Formular::Elements::Input
        include Formular::Elements::Modules::WrappedControl

        attribute :class, ["form-control"]

        def control_html
          Renderer.new(Proc.new {opening_tag(true)}).call(self)
        end
      end #class Input

      class Select < Formular::Elements::Select
        include Formular::Elements::Modules::WrappedControl

        attribute :class, ["form-control"]

        def control_html
          Renderer.new(Proc.new { |input| [opening_tag,input.option_tags,closing_tag].join("") }).call(self)
        end
      end #class Select

      class File < Formular::Elements::Bootstrap3::Input
        include Formular::Elements::Modules::WrappedControl

        add_option_keys [:error_options, :label_options, :wrapper_options]

        attribute :class, []
        attribute :type, "file"
      end #class File

      class Textarea < Formular::Elements::Textarea
        include Formular::Elements::Modules::WrappedControl
        attribute :class, ["form-control"]

        def control_html
          Renderer.new(Proc.new { |input| [opening_tag,input.content,closing_tag].join("") }).call(self)
        end
      end #class Textarea

      class Wrapper < Formular::Element
        include Formular::Elements::Modules::Container
        tag "div"
        attribute :class, ["form-group"]
      end #class Wrapper

      class ErrorWrapper < Formular::Elements::Bootstrap3::Wrapper
        tag "div"
        attribute :class, ["has-error"]
      end #class Wrapper

      Label = Class.new(Formular::Elements::Label) { attribute :class, ["control-label"] }
      Submit = Class.new(Formular::Elements::Submit) { attribute :class, ["btn", "btn-default"] }
    end #module Bootstrap3
  end #module Elements
end #module Formular
