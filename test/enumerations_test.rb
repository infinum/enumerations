# frozen_string_literal: true

require_relative 'helpers/test_helper'
require 'enumerations/errors'

class EnumerationsTest < Minitest::Test # rubocop:disable Metrics/ClassLength
  def test_reflect_on_all_enumerations
    enumerations = Post.reflect_on_all_enumerations

    assert_equal 2, enumerations.size
    assert_equal :status, enumerations.first.name
    assert_equal 'Status', enumerations.first.class_name

    assert_equal :some_other_status, enumerations[1].foreign_key
  end

  def test_model_enumeration_assignment
    p = Post.new
    p.status = Status.draft

    assert_equal 'draft', p.status.to_s
  end

  def test_model_bang_assignment
    p = Post.new
    p.status_draft!

    assert_equal 'draft', p.status.to_s
  end

  def test_model_uniqueness_validation
    p = Post.new(status: :draft)

    assert_equal true, p.valid?
  end

  def test_model_bang_assignment_with_custom_name
    p = Post.new
    p.different_status_draft!

    assert_equal 'draft', p.different_status.to_s
  end

  def test_model_via_symbol_assignment
    p = Post.new
    p.some_other_status = Status.published.symbol

    assert_equal 'published', p.some_other_status.to_s
  end

  def test_boolean_lookup
    p = Post.new
    p.status = Status.draft

    assert_equal true, p.status.draft?
  end

  def test_false_boolean_lookup
    p = Post.new
    p.status = Status.draft

    assert_equal false, p.status.published?
  end

  def test_multiple_enumerations_on_model
    enumerations = User.reflect_on_all_enumerations

    assert_equal 2, enumerations.size

    assert_equal :role, enumerations.first.name
    assert_equal :role, enumerations.first.foreign_key

    assert_equal :status, enumerations[1].name
    assert_equal :status, enumerations[1].foreign_key
  end

  def test_multiple_enumeration_assignments_on_model
    u = User.new
    u.role = Role.admin
    u.status = Status.published

    assert_equal 'admin', u.role.to_s
    assert_equal 'published', u.status.to_s
  end

  def test_enumerated_class_has_enumeration_scope
    assert_respond_to User, :with_role
  end

  def test_enumerated_class_has_scopes
    Role.all.each do |role|
      assert_respond_to User, ['with_role', role.to_s].join('_').to_sym
    end
  end

  def test_enumerated_class_enumeration_scope_hash_value
    query_hash = User.with_role(:admin).where_values_hash.symbolize_keys

    assert_equal query_hash, role: :admin
  end

  def test_enumerated_class_enumeration_without_scope_results
    User.create(role: :admin)
    User.create(role: :editor)

    results = User.without_role(:admin)

    assert_equal results, User.where.not(role: :admin)
  end

  def test_enumerated_class_enumeration_scope_hash_value_for_multiple_enums
    query_hash = User.with_role(:admin, Role.author, 'editor').where_values_hash.symbolize_keys

    assert_equal query_hash, role: [:admin, :author, :editor]
  end

  def test_enumerated_class_enumeration_scope_hash_value_for_multiple_enums_as_array
    query_hash = User.with_role([:admin, Role.author, 'editor']).where_values_hash.symbolize_keys

    assert_equal query_hash, role: [:admin, :author, :editor]
  end

  def test_enumerated_class_without_scope_hash_value
    query_hash = User.with_role_admin.where_values_hash.symbolize_keys

    assert_equal query_hash, role: :admin
  end

  def test_enumerated_class_without_scope_results
    User.create(role: :admin)
    User.create(role: :editor)

    results = User.without_role_admin

    assert_equal results, User.where.not(role: :admin)
  end

  def test_nonexistent_value_assignment
    assert_raises Enumerations::InvalidValueError do
      User.new(role: :nonexistent_value)
    end
  end

  def test_nonexistent_value_assignment_with_error_raising_turned_off
    Enumerations.configuration.raise_invalid_value_error = false

    user = User.new(role: :nonexistent_value)

    assert_equal user.role, 'nonexistent_value'

    user.role = :other_nonexistent_value

    assert_equal user.role, 'other_nonexistent_value'

    Enumerations.configuration.raise_invalid_value_error = true
  end

  def test_on_nil_value_assignment
    user = User.new(role: nil)
    assert_nil user.role
  end

  def test_type_cast_when_saving_value_to_database
    client = ApiClient.new(api_client_permission: ApiClientPermission.people_first_name)
    client.save

    # overriding to_s doesn't have an effect on the value saved to the database
    assert_equal 'people_first_name', client[:api_client_permission]
  end
end
