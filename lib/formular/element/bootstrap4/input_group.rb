require 'formular/elements'
require 'formular/element/bootstrap3/input_group'

module Formular
  class Element
    module Bootstrap4
      class InputGroup < Formular::Element::Bootstrap3::InputGroup
        set_default :label_options, { class: ['form-control-label'] }
      end # class InputGroup
    end # module Bootstrap4
  end # class Element
end # module Formular
