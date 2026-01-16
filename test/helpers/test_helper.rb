# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require 'enumerations'
require 'active_record'
require 'pry'

require_relative 'database_helper'
require_relative 'locale_helper'

class Status < Enumerations::Base
  values draft: { id: 1, name: 'Draft' },
         review_pending: { id: 2, name: 'Review pending' },
         published: { id: 3, name: 'Published' }

  value :none,    id: 4, name: 'None', visible: true, deleted: false
  value :deleted, id: 5, deleted: true
end

class Role < Enumerations::Base
  value :admin,     name: 'Admin',  admin: true, active: true
  value :editor,    name: 'Editor', admin: true, active: false, description: 'Edits newspapers'
  value :author,    name: 'Author'
  value :lecturer,  type: :croatist

  def my_custom_name
    ['user', name].join('_')
  end
end

class ApiClientPermission < Enumerations::Base
  value :people_first_name, id: 'people.first_name'
  value :people_last_name, id: 'people.last_name'

  def to_s
    id
  end
end

class ApiClient < ActiveRecord::Base
  enumeration :api_client_permission
end

class Post < ActiveRecord::Base
  enumeration :status
  enumeration :different_status, foreign_key: :some_other_status, class_name: 'Status'

  validates :status, uniqueness: true
end

class User < ActiveRecord::Base
  enumeration :role
  enumeration :status
end

class OverridableStatus < Enumerations::Base
  self.primary_key = :id
  self.foreign_key_suffix = :id

  value :draft, id: 1
end

class OverridableModel < ActiveRecord::Base
  enumeration :overridable_status
end
