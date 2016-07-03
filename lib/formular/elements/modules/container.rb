require 'formular/elements/module'
module Formular
  module Elements
    module Modules
      # this module is used for elements that contain something
      # e.g. <label>Label Words</label>
      # it is designed to accept content as a string or as a block
      # if no content it will just provide the opening tag,
      # you can then add your own content and close manually by calling `.end`
      module Container
        include Formular::Elements::Module

        add_option_keys :content

        html do |element|
          element.has_content? ? element.to_html(context: :with_content) : element.start_tag
        end

        html(:with_content) do |element, output|
          output.concat element.start_tag
          output.concat element.content
          output.concat element.end_tag
        end

        html(:end) { |element| element.end_tag }

        module InstanceMethods
          def content
            @block ? HtmlBlock.new(@block).call(self) : options[:content]
          end

          def has_content?
            @block || options[:content]
          end

          def end
            to_html(context: :end)
          end

          # Delegate missing methods to the builder
          # The only way to get rid of this is to make the builder available
          # to the block.
          # could we make html_blocks work without requiring block params?
          # html do
          #   has access to `builder`, `element` and `output`
          #   variables without needing block
          # end

          # People trying to use containers without blocks would need to store the builder
          # as a variable, not the block element. E.g. this wont work
          # f = Builder.new.form
          #   f.some_form_element
          # f.end
          #
          # You'd need to do this instead...
          # f = Builder.new
          # f.form
          #   f.some_form_element
          # f.end
          def method_missing(method, *args, &block)
            return super unless builder

            builder.send(method, *args, &block)
          end
        end # module InstanceMethods
      end # module Container
    end # module Modules
  end # module Elements
end # module Formular
