$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "formular"
require "minitest/autorun"

require "cells-slim"

Comment = Struct.new(:id, :body, :replies, :uuid, :public, :errors) # TODO: remove errors!
Reply   = Struct.new(:id, :errors)
