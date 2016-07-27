require 'formular/element/module'
module Formular
  class Element
    module Modules
      # this module is used for element that contain something
      # e.g. <label>Label Words</label>
      # it is designed to accept content as a string (via the :content option)
      # or as a block
      # Alternatively you can produce blockless content by making use of the
      # #start and #end methods e.g.
      #
      # element = Container.()
      # element.start
      # add your own content
      # element.end
      module Container
        include Formular::Element::Module

        add_option_keys :content

        html do |element|
          concat start_tag
          concat element.content
          concat end_tag
        end

        html(:start) { start_tag }

        html(:end) { end_tag }

        module InstanceMethods
          def content
            @block ? HtmlBlock.new(self, @block).call : options[:content].to_s
          end

          def has_content?
            @block || options[:content]
          end

          def end
            to_html(context: :end)
          end

          def start
            to_html(context: :start)
          end

          # Delegate missing methods to the builder
          # TODO:: @apotonick is going to do something fancy here to delegate
          # the builder methods rather then using this method missing.
          def method_missing(method, *args, &block)
            return super unless builder

            builder.send(method, *args, &block)
          end
        end # module InstanceMethods
      end # module Container
    end # module Modules
  end # class Element
end # module Formular
