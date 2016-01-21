$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "formular"
require "minitest/autorun"

require "cells-slim"

Comment = Struct.new(:id, :body, :replies, :uuid, :public, :errors) # TODO: remove errors!
Reply   = Struct.new(:id, :email, :errors)


require "reform"
require "reform/form/dry"

module F5
  class Form < Reform::Form
    include Dry::Validations

    property :id
    property :uuid
    property :body

    validation :default do
      key(:uuid) { |uuid| uuid.filled? }
      key(:body) { |body| body.max_size?(10) }
    end

    collection :replies do
      property :email
    end
  end
end
