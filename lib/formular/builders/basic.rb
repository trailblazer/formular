require 'formular/builder'
require 'formular/elements'
module Formular
  module Builders
    # I'm not quite sure why I made this a seperate class
    # But I kind of see myself having Builder as a generic
    # viewbuilder and this basic class as Form
    class Basic < Formular::Builder
      element_set(
        error_notification: Formular::Element::ErrorNotification,
        form: Formular::Element::Form,
        fieldset: Formular::Element::Fieldset,
        legend: Formular::Element::Legend,
        div: Formular::Element::Div,
        span: Formular::Element::Span,
        p: Formular::Element::P,
        input: Formular::Element::Input,
        hidden: Formular::Element::Hidden,
        label: Formular::Element::Label,
        error: Formular::Element::Error,
        hint: Formular::Element::P,
        textarea: Formular::Element::Textarea,
        submit: Formular::Element::Submit,
        select: Formular::Element::Select,
        checkbox: Formular::Element::Checkbox,
        radio: Formular::Element::Radio,
        wrapper: Formular::Element::Div,
        error_wrapper: Formular::Element::Div
      )

      def initialize(model: nil, path_prefix: nil, errors: nil, values: nil, elements: {})
        @model = model
        @path_prefix = path_prefix
        @errors = errors || (model ? model.errors : {})
        @values = values || {}
        super(elements)
      end
      attr_reader :model, :errors, :values

      def collection(name, models: nil, builder: nil, &block)
        models ||= model ? model.send(name) : []

        models.map.with_index do |model, i|
          nested(name, nested_model: model, path_appendix: [name,i], builder: builder, &block)
        end.join('')
      end

      def nested(name, nested_model: nil, path_appendix: nil, builder: nil, &block)
        nested_model ||= model.send(name) if model
        path_appendix ||= name
        builder ||= self.class
        builder.new(model: nested_model, path_prefix: path(path_appendix)).(&block)
      end

      # these can be called from an element
      def path(appendix = nil)
        appendix ? Path[*@path_prefix, appendix] : Path[@path_prefix]
      end

      def reader_value(name)
        model ? model.send(name) : values[name.to_sym]
      end
    end # class Basic
  end # module Builders
end # module Formular
