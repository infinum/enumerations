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

    assert_equal 3, statuses.size
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
    
    assert_equal "Draft", p.status.to_s
  end
  
  def test_model_via_id_assignment
    p = Post.new    
    p.some_other_status_id = Status.published.id
    
    assert_equal "Published", p.different_status.to_s
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
end