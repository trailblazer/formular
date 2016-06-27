require 'formular/element'
require 'formular/elements'
require 'formular/elements/modules/container'
require 'formular/elements/module'
require 'formular/elements/bootstrap3'
module Formular
  module Elements
    module Bootstrap3
      module Horizontal
        module WrappedControl
          include Formular::Elements::Module

          html do |input|
            input.wrapper do |wrapper|
              concat input.label
              concat wrapper.input_column_wrapper(content: input.control_html + input.error).to_s
            end.to_s
          end
        end

        Form = Class.new(Formular::Elements::Form) { set_default :class, ['form-horizontal'] }
        Select = Class.new(Formular::Elements::Bootstrap3::Select) { include WrappedControl }
        Textarea = Class.new(Formular::Elements::Bootstrap3::Textarea) { include WrappedControl }
        Input = Class.new(Formular::Elements::Bootstrap3::Input) { include WrappedControl }
        File = Class.new(Formular::Elements::Bootstrap3::File) { include WrappedControl }

        class InputColumnWrapper < Formular::Elements::Container
          set_default :class, :column_class
          tag 'div'

          def column_class
            builder.class.column_classes[:right_column]
          end
        end # class InputColumnWrapper

        class Label < Formular::Elements::Bootstrap3::Label
          set_default :class, :column_class

          def column_class
            builder.class.column_classes[:left_column] + ['control-label']
          end
        end # class Label

        class Submit < Formular::Elements::Bootstrap3::Submit
          set_default :class, :column_class

          def column_class
            builder.class.column_classes[:left_offset] + builder.class.column_classes[:left_column]
          end
        end # class Submit
      end # module Horizontal
    end # module Bootstrap3
  end # module Elements
end # module Formular
