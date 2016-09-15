require 'logger'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

ActiveRecord::Schema.define do
  create_table :posts, force: true do |t|
    t.string :status
    t.string :some_other_status
  end

  create_table :users, force: true do |t|
    t.string :role
    t.string :status
  end
end
