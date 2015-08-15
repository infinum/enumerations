Enumerations
============

Rails plugin for enumerations in ActiveRecord models.

Install
=======

If you are using **Bundler** (and you should be), just add it as a `gem`:

```ruby
gem 'enumerations'
```

If not, then install it as a plugin:

    rails plugin install git://github.com/infinum/enumerations.git

Usage
=====

Create a model for your enumerations:

```ruby
class Status < Enumeration::Base
  values draft:           { id: 1, name: 'Draft' },
         review_pending:  { id: 2, name: 'Review pending' },
         published:       { id: 3, name: 'Published' }
end
```

Include enumerations for integer fields in other models:

```ruby
class Post < ActiveRecord::Base
  enumeration :status
  validates_presence_of :body, :title, :status_id
end
```

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

Find enumerations by `id`:

```ruby
@post.status = Status.find(2)               # => Review pending
@post.save
```

Compare enumerations:

```ruby
@post.status == :published                  # => true
@post.status == 3                           # => true
@post.status == Status.find(:published)     # => true
@post.status.published?                     # => true
```

Get all enumerations:

```ruby
Status.all
```

Use in forms:

```ruby
%p
  = f.label :status_id
  %br
  = f.collection_select :status_id, Status.all, :id, :name
```

TODO
====

* support for object values (not just symbols and strings)

Author
======

Copyright © 2010 Tomislav Car, Infinum Ltd.
