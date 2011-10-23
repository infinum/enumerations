Enumerations
==========

Rails plugin for enumerations in ActiveRecord models

Install
=======

    rails plugin install git://github.com/infinum/enumerations.git

Usage
=====

Create a model for your enumerations

    class Status < Enumeration::Base
      values :draft => {:id => 1, :name => 'Draft'},
             :review_pending => {:id => 2, :name => 'Review pending'},
             :published => {:id => 3, :name => 'Published'}  
    end

Include enumerations for integer fields in other models

    class Post < ActiveRecord::Base
      enumeration :status
      validates_presence_of :body, :title, :status_id
    end

Set enumerations, find enumerations by symbol

    @post = Post.first
    @post.status = Status.find(:draft)
    @post.save

Find enumerations by id

    @post.status = Status.find(2) # => Review pending
    @post.save

Compare enumerations

    @post.status == :published                  # => true
    @post.status == 3                           # => true
    @post.status == Status.find(:published)     # => true
    @post.status.published?                     # => true

Get all enumerations

    Status.all

Use in forms

    %p
      = f.label :status_id
      %br
      = f.collection_select :status_id, Status.all, :id, :name

Author
======

Copyright (c) 2010 Tomislav Car, Infinum

