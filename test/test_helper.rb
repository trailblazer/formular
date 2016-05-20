$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "formular"
require "minitest/autorun"

Comment = Struct.new(:id, :body, :replies, :uuid, :public, :errors, :owner) # TODO: remove errors!
Reply   = Struct.new(:id, :email, :errors)
Owner   = Struct.new(:id, :errors)


require "reform"
require "reform/form/dry"