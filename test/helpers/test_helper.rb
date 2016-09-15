require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require 'minitest/autorun'
require 'enumerations'
require 'active_record'
require 'pry'

require_relative 'database_helper'
require_relative 'locale_helper'

class Status < Enumerations::Base
  values draft:           { id: 1, name: 'Draft' },
         review_pending:  { id: 2, name: 'Review pending' },
         published:       { id: 3, name: 'Published' }

  value :none,    id: 4, name: 'None', visible: true, deleted: false
  value :deleted, id: 5, deleted: true
end

class Role < Enumerations::Base
  value :admin,   id: 1, name: 'Admin',  admin: true, active: true
  value :editor,  id: 2, name: 'Editor', admin: true, active: false, description: 'Edits newspapers'
  value :author,  id: 3, name: 'Author'

  def my_custom_name
    ['user', name].join('_')
  end
end

class Post < ActiveRecord::Base
  attr_accessor :status, :some_other_status

  enumeration :status
  enumeration :different_status, foreign_key: :some_other_status, class_name: 'Status'
end

class User < ActiveRecord::Base
  attr_accessor :role, :status

  enumeration :role
  enumeration :status
end
