require 'formular/builder'
require 'formular/elements'
module Formular
  module Builders
    # I'm not quite sure why I made this a seperate class
    # But I kind of see myself having Builder as a generic
    # viewbuilder and this basic class as Form
    class Basic < Formular::Builder
      element_set(
        error_notification: Formular::Elements::ErrorNotification,
        form: Formular::Elements::Form,
        fieldset: Formular::Elements::Fieldset,
        legend: Formular::Elements::Legend,
        div: Formular::Elements::Div,
        span: Formular::Elements::Span,
        p: Formular::Elements::P,
        input: Formular::Elements::Input,
        hidden: Formular::Elements::Hidden,
        label: Formular::Elements::Label,
        error: Formular::Elements::Error,
        hint: Formular::Elements::P,
        textarea: Formular::Elements::Textarea,
        submit: Formular::Elements::Submit,
        select: Formular::Elements::Select,
        checkbox: Formular::Elements::Checkbox,
        radio: Formular::Elements::Radio,
        wrapper: Formular::Elements::Div,
        error_wrapper: Formular::Elements::Div
      )

      def initialize(model: nil, path_prefix: nil, errors: nil, elements: {})
        @model = model
        @path_prefix = path_prefix
        @errors = errors || (model ? model.errors : {})
        super(elements)
      end
      attr_reader :model, :errors

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
        model ? model.send(name) : nil
      end
    end # class Basic
  end # module Builders
end # module Formular
