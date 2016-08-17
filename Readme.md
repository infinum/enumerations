Enumerations
============

[![Gem Version](https://badge.fury.io/rb/enumerations.svg)](https://badge.fury.io/rb/enumerations)
[![Code Climate](https://codeclimate.com/github/infinum/enumerations/badges/gpa.svg)](https://codeclimate.com/github/infinum/enumerations)
[![Build Status](https://semaphoreci.com/api/v1/infinum/enumerations/branches/master/shields_badge.svg)](https://semaphoreci.com/infinum/enumerations)
[![Test Coverage](https://codeclimate.com/github/infinum/enumerations/badges/coverage.svg)](https://codeclimate.com/github/infinum/enumerations/coverage)

Rails plugin for enumerations in ActiveRecord models.

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
class Status < Enumeration::Base
  values draft:           { id: 1, name: 'Draft' },
         review_pending:  { id: 2, name: 'Review pending' },
         published:       { id: 3, name: 'Published' }
end
```

Or you can use `value` method for defining your enumerations:

```ruby
class Status < Enumeration::Base
  value :draft,           id: 1, name: 'Draft'
  value :review_pending,  id: 2, name: 'Review pending'
  value :published,       id: 3, name: 'Published'
end
```

Include enumerations for integer fields in other models:

```ruby
class Post < ActiveRecord::Base
  enumeration :status
  validates :status_id, presence: true
end
```

You can pass attributes to specify which enumeration and which column to use:

```ruby
class Post < ActiveRecord::Base
  enumeration :status,
              foreign_key: :post_status_id,   # specifies which column to use
              class_name: Post::Status        # specifies the class of the enumerator
  validates :post_status_id, presence: true
end
```
Attribute `foreign_key` you can pass as a `String` or a `Symbol`. Attribute `class_name` can be set as a `String`, a `Symbol` or a `String`.



## Setting enumeration value to objects

Set enumerations, find enumerations by `symbol`:

```ruby
@post = Post.first
@post.status = Status.find(:draft)
@post.save
```

Or you can set enumerations on this way:

```ruby
@post.status = Status.draft
```

Also, you can set enumeration value like this:

```ruby
@post.status_draft!
```

> When you include enumerations into your model, you'll get methods for setting each enumeration value. Each method name is consists from enumeration name and enumeration value name with **!** at the end. Examples:

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
@post.status = Status.find(2)                  # => Review pending
@post.save
```

Compare enumerations:

```ruby
@post.status == :published                     # => true
@post.status == 3                              # => true
@post.status == Status.find(:published)        # => true
@post.status.published?                        # => true
```

Get all enumerations:

```ruby
Status.all
```



## Scopes on model

With enumerations, you'll get scope for each enumeration value in the
following format:

```ruby
with_#{enumeration_name}_#{enumeration_value_name}
```

Examples:

```ruby
class Post < ActiveRecord::Base
  enumeration :status
end

Post.with_status_draft                        # => <#ActiveRecord::Relation []>
Post.with_status_review_pending               # => <#ActiveRecord::Relation []>
```

```ruby
class Post < ActiveRecord::Base
  enumeration :my_status, class_name: Status
end

Post.with_my_status_draft                      # => <#ActiveRecord::Relation []>
Post.with_my_status_review_pending             # => <#ActiveRecord::Relation []>
```

Each scope returns all records with specified enumeration value.



## Forms usage

Use in forms:

```ruby
%p
  = f.label :status_id
  %br
  = f.collection_select :status_id, Status.all, :id, :name
```

Advance Usage
=====

Except `id` and `name` you can specify other attributes to your enumerations:

```ruby
class Status < Enumeration::Base
  value :draft,           id: 1, name: 'Draft'
  value :review_pending,  id: 2, name: 'Review pending', description: 'Some description...'
  value :published,       id: 3, name: 'Published'
end
```

Every enumeration has `id`, `name` and `description` methods. If you call method that is not in attribute list for enumeration, it will return `nil`.

```ruby
Status.review_pending.description              # => 'Some description...'
Status.draft.description                       # => nil
```

Author
======

Copyright © 2010 Tomislav Car, Infinum Ltd.
