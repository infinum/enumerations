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

You can use a gem for the migration, or just write raw SQL.

Your migrations will look something like this:

First to change the column types
```ruby
class MoveMyEnumToNewEnumerationsColumns
  def up
    rename_column :my_table, :my_enum_id, :my_enum
    change_column :my_table, :my_enum, :string
  end

  def down
    change_column :my_table, :my_enum, 'integer USING CAST(my_enum AS integer)'
    rename_column :my_table, :my_enum, :my_enum_id
  end
end
```

And now for the actual data

```ruby
class MoveMyEnumToNewEnumerations < ActiveRecord::Migration
  def up
    execute(<<-SQL
      UPDATE my_table
      SET my_enum =
        CASE my_enum
        WHEN '1' THEN 'first'
        WHEN '2' THEN 'second'
        WHEN '3' THEN 'third'
        END
    SQL
    )
  end

  def down
    execute(<<-SQL
      UPDATE my_table
      SET my_enum =
        CASE my_enum
        WHEN 'first' THEN '1'
        WHEN 'second' THEN '2'
        WHEN 'third' THEN '3'
        END
    SQL
    )
end
```

And that's it, you won't need an initializer for this to work anymore, because these are the default options Enumeration gem ships with.
