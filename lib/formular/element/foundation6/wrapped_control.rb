require 'formular/element/module'
require 'formular/element/modules/wrapped_control'
module Formular
  class Element
    module Foundation6
      module WrappedControl
        include Formular::Element::Module
        include Formular::Element::Modules::WrappedControl

        html(:wrapped) do |input|
          input.wrapper do
            concat input.label_text
            concat input.to_html(context: :default)
            concat input.hint
            concat input.error
          end.to_s
        end
      end # module WrappedControl
    end # module Foundation6
  end # class Element
end # module Formular
