# TODO: improve tests
require 'minitest/autorun'
require 'enumerations'
require 'pry'

# Faking ActiveRecord
class MockActiveRecordBase
  include Enumeration
end

class Status < Enumeration::Base
  values draft:           { id: 1, name: 'Draft' },
         review_pending:  { id: 2, name: 'Review pending' },
         published:       { id: 3, name: 'Published' }

  value :none,    id: 4, name: 'None', visible: true
  value :deleted, id: 5, deleted: true
end

class Post < MockActiveRecordBase
  attr_accessor :status_id, :some_other_status_id

  enumeration :status
  enumeration :different_status, foreign_key: :some_other_status_id, class_name: 'Status'
end
