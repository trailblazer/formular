require 'formular/elements/module'
require 'formular/elements/modules/wrapped_control'
module Formular
  module Elements
    module Foundation6
      module WrappedControl
        include Formular::Elements::Module
        include Formular::Elements::Modules::WrappedControl

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
  end # module Elements
end # module Formular
