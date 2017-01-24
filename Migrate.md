How to migrate from 1.x.x
=========================

Changes in the namespace
========================

First off, start by renaming your namespaces, what used to be

```ruby
class MyClass < Enumeration::Base
```

will now be

```ruby
class MyClass < Enumerations::Base
```

Configuration
=============

Since v2 has a breaking change of default values in the database columns, you have 2 options:

1. Create an initializer that you will configure to have the old naming conventions
2. Create data migrations and convert your data to be alligned with the new Enumerations

First option might be tempting, but you need to weigh in the advantages of the new enumerations.
With the second option, you can get enumerations in the database instead of ID's, which may prove quite usefull.

First way
=========

You need to create the following initializer

```ruby
# config/initializers/enumerations.rb

Enumerations.configure do |config|
  config.primary_key        = :id
  config.foreign_key_suffix = :id
end
```

And voilà! You can carry on with work knowing your enumerations are up to date.

Second way
==========

Use any gem you see fit, we prefer `data_migrate` gem for this job.

Simply create the data migration with `rails g data_migration name_of_your_migration`

Your migration will look something like this:

```ruby
class MoveMyEnumToNewEnumerations < ActiveRecord::Migration
  def change
    rename_column :my_table, :my_enum_id, :my_enum
    change_column :my_table, :my_enum, :string
  end

  def data
    execute(<<-SQL
      UPDATE my_table
      SET my_enum =
        CASE my_enum
        WHEN '1' THEN 'first'
        WHEN '2' THEN 'second'
        WHEN '3' THEN 'third'
        WHEN '6' THEN 'sixth'
        WHEN '7' THEN 'seventh'
        END
    SQL
    )
  end
end
```

And that's it, you won't need an initializer for this to work anymore, because these are the default options Enumeration gem ships with.
