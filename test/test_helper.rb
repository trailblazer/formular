$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'formular'
require 'minitest/autorun'

Comment = Struct.new(:id, :body, :replies, :owner, :uuid, :public, :agreed, :not_sure, :really_not_sure, :errors) # TODO: remove errors!
Reply   = Struct.new(:id, :content, :errors)
Owner   = Struct.new(:id, :name, :email, :errors)
COLLECTION_ARRAY = [['Option 1', 1], ['Option 2', 2]]

