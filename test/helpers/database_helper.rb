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

  create_table :custom_models, force: true do |t|
    t.integer :custom_enum_id
    t.integer :custom_enum
  end

  create_table :overidable_models, force: true do |t|
    t.integer :overidable_status_id
  end
end
