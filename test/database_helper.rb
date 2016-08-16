require 'logger'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

ActiveRecord::Schema.define do
  create_table :posts, force: true do |t|
    t.string   :title
    t.integer  :status_id
    t.integer  :some_other_status_id
  end

  create_table :users, force: true do |t|
    t.string   :name
    t.integer  :role_id
    t.string   :status_id
  end
end 
