require File.expand_path(File.dirname(__FILE__) + '/test_helper')

class EnumerationsTest < Test::Unit::TestCase
  def test_lookup_by_symbol
    status = Status.find(:draft)

    assert_equal :draft, status.symbol
  end

  def test_lookup_fail_by_symbol
    status = Status.find(:draft)

    assert_not_equal :published, status.symbol
  end

  def test_all
    statuses = Status.all

    assert_equal 5, statuses.size
    assert_equal statuses.first, Status.draft
  end

  def test_reflections
    enumerations = Post.reflect_on_all_enumerations

    assert_equal 2, enumerations.size
    assert_equal :status, enumerations.first.name
    assert_equal 'Status', enumerations.first.class_name

    assert_equal :some_other_status_id, enumerations[1].foreign_key
  end

  def test_model_enumeration_assignment
    p = Post.new
    p.status = Status.draft

    assert_equal 'Draft', p.status.to_s
  end

  def test_model_via_id_assignment
    p = Post.new
    p.some_other_status_id = Status.published.id

    assert_equal 'Published', p.different_status.to_s
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

  def test_equal_by_id
    status = Status.find(:draft)

    assert_equal true, status == 1
  end

  def test_equal_by_symbol
    status = Status.draft

    assert_equal true, status == :draft
  end

  def test_equal_by_enumeration
    status = Status.draft

    assert_equal true, status == Status.draft
  end

  def test_not_equal_by_enumeration
    status = Status.draft

    assert_equal false, status == Status.published
  end

  def test_duplicated_id
    assert_raise 'Duplicate id 1' do
      Class.new.values draft: { id: 1, name: 'Draft' },
                       test:  { id: 1, name: 'Draft' }
    end
  end

  def test_duplicated_symbol
    assert_raise 'Duplicate symbol draft' do
      obj = Class.new

      obj.value :draft, id: 1, name: 'Draft'
      obj.value :draft, id: 2, name: 'Draft Again'
    end
  end

  def test_all_has_custom_attributes
    statuses = Status.all

    assert_nothing_raised NoMethodError do
      statuses.map(&:visible)
      statuses.map(&:deleted)
    end
  end

  def test_with_defined_custom_attributes_visible
    status = Status.find(:none)

    assert_equal true, status.visible
  end

  def test_with_defined_custom_attributes_deleted
    status = Status.find(:deleted)

    assert_equal true, status.deleted
  end

  def test_without_defined_custom_attributes
    status = Status.find(:draft)

    assert_equal nil, status.visible
  end

  def test_name_set_to_humanized_symbol
    status = Status.find(:deleted)

    assert_equal 'Deleted', status.name
  end
end
