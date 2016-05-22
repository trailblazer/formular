require "formular/builder"
require "formular/elements/form"
require "formular/elements/input"
require "formular/elements/label"
require "formular/elements/textarea"
require "formular/elements/submit"

module Formular
  module Builders
    class Basic < Formular::Builder
      self.elements = {
        form: Formular::Elements::Form,
        input: Formular::Elements::Input,
        label: Formular::Elements::Label,
        textarea: Formular::Elements::Textarea,
        submit: Formular::Elements::Submit
      }

      def capture(*args)
        yield(*args)
      end

      def call(&block)
        capture(self, &block)
      end

      def label(name, attributes={}, options={})
        attributes = {for: path(name).to_encoded_id}.merge(Attributes[attributes])
        options[:content] ||= name.to_s.split(/ |\_|\-/).map(&:capitalize).join(" ")
        super(attributes, options)
      end

      def input(name, attributes={}, options={})
        attributes = {name: path(name).to_encoded_name, id: path(name).to_encoded_id, value: reader_value(name)}.merge(Attributes[attributes])
        options[:name] = name
        super(attributes, options)
      end

      def textarea(name, attributes={}, options={})
        attributes = {name: path(name).to_encoded_name, id: path(name).to_encoded_id}.merge(Attributes[attributes])
        options[:content] = attributes.delete(:value) || reader_value(name)
        options[:name] = name
        super(attributes, options)
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
