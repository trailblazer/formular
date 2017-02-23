require 'formular/element/module'
require 'formular/element/modules/wrapped'
module Formular
  class Element
    module Foundation6
      module Wrapped
        include Formular::Element::Module
        include Formular::Element::Modules::Wrapped

        html(:wrapped) do |input|
          input.wrapper do
            concat input.label_text
            concat input.to_html(context: :default)
            concat input.hint
            concat input.error
          end.to_s
        end
      end # module Wrapped
    end # module Foundation6
  end # class Element
end # module Formular
