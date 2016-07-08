require 'formular/elements/module'
require 'formular/elements/modules/wrapped_control'
module Formular
  module Elements
    module Foundation6
      module WrappedControl
        include Formular::Elements::Module
        include Formular::Elements::Modules::WrappedControl

        html(:wrapped) do |input|
          input.wrapper do |_, output|
            output.concat input.label_text
            output.concat input.to_html(context: :default)
            output.concat input.hint
            output.concat input.error
          end.to_s
        end
      end # module WrappedControl
    end # module Foundation6
  end # module Elements
end # module Formular
