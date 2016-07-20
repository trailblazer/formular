require 'formular/elements'
require 'formular/elements/modules/container'
require 'formular/elements/modules/wrapped_control'

module Formular
  module Elements
    module Bootstrap3
      module InputGroups
        class Wrapper < Formular::Elements::Div
          set_default :class, ['input-group']
        end # class Wrapper

        class Addon < Formular::Elements::Span
          set_default :class, ['input-group-addon']
        end # class Addon

        class Btn < Formular::Elements::Span
          set_default :class, ['input-group-btn']
        end # class Btn

        class InputGroup < Formular::Elements::Input
          include Formular::Elements::Modules::WrappedControl
          include Formular::Elements::Modules::Container

          set_default :class, ['form-control']

          add_option_keys :left_addon, :right_addon, :left_btn, :right_btn

          html(:raw_input) { closed_start_tag }

          html do |input|
            content = if input.has_content?
                        input.content
                      else
                        input.to_html(context: :with_options)
                      end
            Wrapper.(content: content)
          end

          def group_addon(content = nil, option_key: nil)
            return '' unless content || option_key
            addon_content = content || options[option_key]
            return '' unless addon_content

            Addon.(content: addon_content)
          end

          def group_btn(content = nil, option_key: nil)
            return '' unless content || option_key
            addon_content = content || options[option_key]
            return '' unless addon_content

            Btn.(content: addon_content)
          end

          def control
            to_html(context: :raw_input)
          end

          html(:with_options) do |input|
            concat input.group_addon(option_key: :left_addon)
            concat input.group_btn(option_key: :left_btn)
            concat input.control
            concat input.group_addon(option_key: :right_addon)
            concat input.group_btn(option_key: :right_btn)
          end
        end # class InputGroup
      end # module InputGroups
    end # module Bootstrap3
  end # module Elements
end # module Formular
