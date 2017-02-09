require_relative 'helpers/test_helper'

class TranslationTest < Minitest::Test
  def test_translated_value_with_default_locale
    status = Status.find(:draft)

    assert_equal 'Draft', status.name
  end

  def test_translated_value_with_i18n_locale
    status = Status.find(:draft)

    I18n.locale = :hr
    translated_name = status.name
    I18n.locale = :en

    assert_equal 'Nacrt', translated_name
  end

  def test_translated_value_with_i18n_locales
    status = Status.find(:draft)

    I18n.locale = :hr
    assert_equal 'Nacrt', status.name
    I18n.locale = :en
    assert_equal 'Draft', status.name
  end

  def test_translated_value_with_custom_locale
    status = Status.find(:draft)

    assert_equal 'Nacrt', status.name(locale: :hr)
  end

  def test_boolean_value_true_not_changed_by_translations
    status = Status.find(:none)

    assert_equal true, status.visible
  end

  def test_boolean_value_false_not_changed_by_translations
    status = Status.find(:none)

    assert_equal false, status.deleted
  end

  def test_boolean_value_false_not_changed_by_translations_with_custom_locale
    status = Status.find(:none)

    assert_equal false, status.deleted(locale: :hr)
  end

  def test_translated_custom_attribute_with_i18n_locale
    role = Role.find(:editor)

    I18n.locale = :hr
    translated_value = role.description
    I18n.locale = :en

    assert_equal 'Uređuje novine', translated_value
  end

  def test_translated_custom_attribute_with_custom_locale
    role = Role.find(:editor)

    assert_equal 'Uređuje novine', role.description(locale: :hr)
  end

  def test_empty_custom_attribute_with_custom_locale
    role = Role.find(:admin)

    assert_nil role.description(locale: :hr)
  end

  def test_empty_custom_attribute_with_custom_locale_and_defined_translation
    role = Role.find(:author)

    assert_nil role.description(locale: :hr)
  end

  def test_find_by_localized_name
    status = Status.find_by(name: 'Draft')

    assert_equal :draft, status.symbol
  end

  def test_find_by_localized_name_with_i18n_locale
    I18n.locale = :hr
    status = Status.find_by(name: 'Nacrt')
    I18n.locale = :en

    assert_nil status
  end
end
