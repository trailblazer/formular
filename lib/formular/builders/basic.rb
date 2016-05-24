require "formular/builder"
require "formular/elements"
require "formular/errors"
module Formular
  module Builders
    #I'm not quite sure why I made this a seperate class
    #But I kind of see myself having Builder as a generic viewbuilder and this basic class as Form
    class Basic < Formular::Builder
      include Formular::Errors

      element_set({
        form: Formular::Elements::Form,
        input: Formular::Elements::Input,
        label: Formular::Elements::Label,
        error: Formular::Elements::Error,
        textarea: Formular::Elements::Textarea,
        submit: Formular::Elements::Submit,
        select: Formular::Elements::Select
      })

      #FIXME!!This should be removed
      #select must be defined somewhere else as if I don't explicitly do this we get TypeError
      #when called from a container
      #TypeError: wrong argument type Symbol (expected Array)
      # def select(*attrs)
      #   method_missing(:select, *attrs)
      # end

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
