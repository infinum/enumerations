Enumerations
============

[![Gem Version](https://badge.fury.io/rb/enumerations.svg)](https://badge.fury.io/rb/enumerations)
[![Maintainability](https://api.codeclimate.com/v1/badges/c3b96c5afceaa9be2173/maintainability)](https://codeclimate.com/github/infinum/enumerations/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/c3b96c5afceaa9be2173/test_coverage)](https://codeclimate.com/github/infinum/enumerations/test_coverage)
![Build Status](https://github.com/infinum/enumerations/actions/workflows/test.yml/badge.svg)

Rails plugin for Enumerations in ActiveRecord models.

Installation
============

Inside your `Gemfile` add the following:

```ruby
gem 'enumerations'
```

Usage
=====

## Defining enumerations

Create a model for your enumerations:

```ruby
class Status < Enumerations::Base
  values draft:           { name: 'Draft' },
         review_pending:  { name: 'Review pending' },
         published:       { name: 'Published' }
end
```

Or you can use `value` method for defining your enumerations:

```ruby
class Status < Enumerations::Base
  value :draft,           name: 'Draft'
  value :review_pending,  name: 'Review pending'
  value :published,       name: 'Published'
end
```

Include enumerations for integer fields in other models:

```ruby
class Post < ActiveRecord::Base
  enumeration :status

  validates :status, presence: true
end
```

You can pass attributes to specify which enumeration and which column to use:

```ruby
class Post < ActiveRecord::Base
  enumeration :status,
              foreign_key: :post_status,   # specifies which column to use
              class_name: Post::Status     # specifies the class of the enumerator

  validates :post_status, presence: true
end
```
Attribute `foreign_key` you can pass as a `String` or a `Symbol`. Attribute `class_name` can be set as a `String`, a `Symbol` or a `String`.



## Setting enumeration value to objects

Set enumerations:

```ruby
@post = Post.first
@post.status = Status.draft
@post.save
```

Or you can set enumerations by `symbol`:

```ruby
@post.status = Status.find(:draft)
```

> If you try to set value that is not an Enumeration value (except `nil`), you will get an `Enumerations::InvalidValueError` exception. You can turn this exception off in configuration.

Also, you can set enumeration value like this:

```ruby
@post.status_draft!
```

> When you include enumerations into your model, you'll get methods for setting each enumeration value.
Each method name is consists from enumeration name and enumeration value name with **!** at the end. Examples:

```ruby
class Post < ActiveRecord::Base
  enumeration :status
end

@post.status_draft!
```

```ruby
class User < ActiveRecord::Base
  enumeration :role
end

@user.role_admin!
```

```ruby
class User < ActiveRecord::Base
  enumeration :type, class_name: Role
end

@user.type_editor!
```



## Finder methods

Find enumerations by `id`:

```ruby
@post.status = Status.find(2)                 # => Review pending
@post.save
```

Other finding methods:

```ruby
# Find by key as a Symbol
Status.find(:review_pending)                  # => Review pending

# Find by key as a String
Status.find('draft')                          # => Draft

# Find by multiple attributes
Status.find_by(name: 'None', visible: true)   # => None
```

Compare enumerations:

```ruby
@post.status == :published                    # => true
@post.status == 'published'                   # => true
@post.status == Status.published              # => true
@post.status.published?                       # => true
```

Get all enumerations:

```ruby
Status.all
```



## Filtering methods

Enumerations can be filtered with `where` method, similar to `ActiveRecord::QueryMethods#where`.

```ruby
Role.where(admin: true)                       # => [Role.admin, Role.editor]
Role.where(admin: true, active: true)         # => [Role.admin]
```



## Scopes on model

With enumerations, you'll get scope for each enumeration value in the
following format:

```ruby
with_#{enumeration_name}_#{enumeration_value_name}
without_#{enumeration_name}_#{enumeration_value_name}
```

or you can use the following scope and pass an array of enumerations:

```ruby
with_#{enumeration_name}(enumeration, ...)
without_#{enumeration_name}(enumeration, ...)
```

Examples:

```ruby
class Post < ActiveRecord::Base
  enumeration :status
end

Post.with_status_draft                        # => <#ActiveRecord::Relation []>
Post.without_status_review_pending            # => <#ActiveRecord::Relation []>
Post.with_status(:draft)                      # => <#ActiveRecord::Relation []>
Post.without_status(:draft)                   # => <#ActiveRecord::Relation []>
Post.with_status(Status.draft)                # => <#ActiveRecord::Relation []>
Post.with_status(:draft, :review_pending)     # => <#ActiveRecord::Relation []>
Post.with_status(Status.draft, 'published')   # => <#ActiveRecord::Relation []>
Post.with_status([:draft, :review_pending])   # => <#ActiveRecord::Relation []>
```

```ruby
class Post < ActiveRecord::Base
  enumeration :my_status, class_name: Status
end

Post.with_my_status_draft                      # => <#ActiveRecord::Relation []>
Post.with_my_status_review_pending             # => <#ActiveRecord::Relation []>
Post.with_my_status(:draft)                    # => <#ActiveRecord::Relation []>
Post.without_my_status(:draft)                 # => <#ActiveRecord::Relation []>
```

Each scope returns all records with specified enumeration value.



## Forms usage

Use in forms:

```ruby
%p
  = f.label :status
  %br
  = f.collection_select :status, Status.all, :symbol, :name
```



## Validating input

Enumerations will by default raise an exception if you try to set an invalid value. This prevents usage of validations, which you might want to add if you're developing an API and have to return meaningful errors to API clients.

You can enable validations by first disabling error raising on invalid input (see [configuration](#configuration)). Then, you should add an inclusion validation to enumerated attributes:
```ruby
class Post < ActiveRecord::Base
  enumeration :status

  validates :status, inclusion: { in: Status.all }
end
```

You'll now get an appropriate error message when you insert an invalid value:
```ruby
> post = Post.new(status: 'invalid')
> post.valid?
=> false
> post.errors.full_messages.to_sentence
=> "Status is not included in the list"
> post.status
=> "invalid"
```

Advanced Usage
=====

Except `name` you can specify any other attributes to your enumerations:

```ruby
class Status < Enumerations::Base
  value :draft,           id: 1, name: 'Draft', published: false
  value :review_pending,  id: 2, name: 'Review pending', description: 'Some description...'
  value :published,       id: 3, name: 'Published', published: true
  value :other                                 # passing no attributes is also allowed
end
```

Every enumeration has `id`, `name`, `description` and `published` methods.
If you call method that is not in attribute list for enumeration, it will return `nil`.

```ruby
Status.review_pending.description              # => 'Some description...'
Status.draft.description                       # => nil
```

For each attribute, you have predicate method. Predicate methods are actually calling `present?`
method on attribute value:

```ruby
Status.draft.name?                             # => true
Status.draft.published?                        # => false
Status.published.published?                    # => true
Status.other.name?                             # => false
```

Translations
=====

**Enumerations** uses power of I18n API (if translate_attributes configuration is set to true) to enable you to create a locale file
for enumerations like this:

```yaml
---
en:
  enumerations:
    status:
      draft:
        name: Draft
        description: Article draft...
        ...
    role:
      admin:
        name: Administrator
```

> You can separate enumerations locales into a separate `*.yml` files.
> Then you should add locale file paths to I18n load path:

```ruby
# config/initializers/locale.rb

# Where the I18n library should search for translation files (e.g.):
I18n.load_path += Dir[Rails.root.join('config', 'locales', 'enumerations', '*.yml')]
```

Configuration
=============

Basically no configuration is needed.

**Enumerations** has four configuration options.
You can customize primary key, foreign key suffix, whether to translate attributes and whether to raise `Enumerations::InvalidValueError` exception when setting invalid values.
Just add initializer file to `config/initializers/enumerations.rb`.

Example of configuration:

```ruby
# config/initializers/enumerations.rb

Enumerations.configure do |config|
  config.primary_key               = :id
  config.foreign_key_suffix        = :id
  config.translate_attributes      = true
  config.raise_invalid_value_error = true
end
```

By default, `primary_key` and `foreign_key_suffix` are set to `nil`.

By default model enumeration value is saved to column with same name as enumeration.
If you set enumeration as:
```ruby
enumeration :status
```
then model should have `status` column (as `String` type).
If you want save an `ID` to this column, you can set `foreign_key_suffix` to `id`.
Then model should have `status_id` column.

If you set `primary_key` then you need provide this attribute for all enumerations values.
Also, value from `primary_key` attribute will be stored to model as enumeration value.

For example:

```ruby
# with default configuration

post = Post.new
post.status = Status.draft      # => post.status = 'draft'

# with configured primary_key and foreign_key_suffix:

Enumerations.configure do |config|
  config.primary_key        = :id
  config.foreign_key_suffix = :id
end

class Status < Enumerations::Base
  value :draft,           id: 1, name: 'Draft'
  value :review_pending,  id: 2, name: 'Review pending',
  value :published,       id: 3, name: 'Published', published: true
end

post = Post.new
post.status = Status.draft      # => post.status_id = 1
```

If you want to configure primary key per enumeration class, you can use `primary_key=` class method:

```ruby
class Status < Enumerations::Base
  self.primary_key = :id

  value :draft,           id: 1, name: 'Draft'
  value :review_pending,  id: 2, name: 'Review pending'
end
```

Database Enumerations
=====================

By default, enumeration values are saved to database as `String`.
If you want, you can define `Enum` type in database:

```sql
CREATE TYPE status AS ENUM ('draft', 'review_pending', 'published');
```

Then you'll have enumeration as type in database and you can use it in database migrations:

```ruby
add_column :posts, :status, :status, index: true
```

With configuration option `primary_key`, you can store any type you want (e.g. `Integer`).

Also, for performance reasons, you should add indices to enumeration column.

[Here](https://www.postgresql.org/docs/9.1/static/datatype-enum.html) you can find more informations about ENUM types.



Contributing
============

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Credits
=======
**Enumerations** is maintained and sponsored by [Infinum](https://infinum.co)

Copyright © 2010 - 2018 Infinum Ltd.

License
=======

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
