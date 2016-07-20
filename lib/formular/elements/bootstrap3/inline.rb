require 'formular/elements'
require 'formular/elements/bootstrap3'
module Formular
  module Elements
    module Bootstrap3
      module Inline
        class Form < Formular::Elements::Form
          set_default :class, ['form-inline']
        end # class Form
      end # module Inline
    end # module Bootstrap3
  end # module Elements
end # module Formular
