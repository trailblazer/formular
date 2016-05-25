require "formular/builder"
require "formular/elements"
module Formular
  module Builders
    #I'm not quite sure why I made this a seperate class
    #But I kind of see myself having Builder as a generic viewbuilder and this basic class as Form
    class Basic < Formular::Builder
      element_set({
        form: Formular::Elements::Form,
        input: Formular::Elements::Input,
        label: Formular::Elements::Label,
        error: Formular::Elements::Error,
        textarea: Formular::Elements::Textarea,
        submit: Formular::Elements::Submit,
        select: Formular::Elements::Select
      })

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
