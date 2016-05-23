require "formular/builder"
require "formular/elements/form"
require "formular/elements/error"
require "formular/elements/input"
require "formular/elements/label"
require "formular/elements/textarea"
require "formular/elements/submit"
require "formular/elements/select"

require "formular/errors"
module Formular
  module Builders
    class Basic < Formular::Builder
      include Formular::Errors

      self.elements = {
        form: Formular::Elements::Form,
        input: Formular::Elements::Input,
        label: Formular::Elements::Label,
        error: Formular::Elements::Error,
        textarea: Formular::Elements::Textarea,
        submit: Formular::Elements::Submit,
        select: Formular::Elements::Select
      }

      def capture(*args)
        yield(*args)
      end

      def call(&block)
        capture(self, &block)
      end

      def label(name, options={})
        opts = { for: path(name).to_encoded_id }.merge(Attributes[options])
        opts[:content] ||= name.to_s.split(/ |\_|\-/).map(&:capitalize).join(" ")
        method_missing(:label, opts)
      end

      def input(name, options={})
        opts = { attribute_name: name, name: path(name).to_encoded_name, id: path(name).to_encoded_id, value: reader_value(name)}.merge(Attributes[options])
        method_missing(:input, opts)
      end

      def error(name, options={})
        message = options[:content] || error_message(name)
        return "" unless message
        opts = { attribute_name: name, content: message }.merge(Attributes[options])
        method_missing(:error, opts)
      end

      def select(name, collection_array, options={})
        opts = { name: path(name).to_encoded_name, id: path(name).to_encoded_id, collection: collection_array, value: reader_value(name), attribute_name: name }.merge(Attributes[options])
        method_missing(:select, opts)
      end

      def textarea(name, options={})
        opts = { attribute_name: name, name: path(name).to_encoded_name, id: path(name).to_encoded_id }.merge(Attributes[options])
        opts[:content] = opts.delete(:value) || reader_value(name)
        method_missing(:textarea, opts)
      end

      def collection(name, models = nil, &block)
        models ||= model? ? model.send(name) : []

        models.map.with_index do |model, i|
          nested(name, nested_model: model, path_appendix: [name,i], &block)
        end.join("")
      end

      def nested(name, nested_model: nil, path_appendix: nil, &block)
        nested_model ||= model.send(name) if model?
        path_appendix ||= name
        self.class.new(model: nested_model, path: path(path_appendix)).(&block)
      end
    end #class Basic
  end #module Builders
end #module Formular
