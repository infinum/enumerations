module Configuration
  Enumerations.configure do |config|
    config.primary_key        = :id
    config.foreign_key_suffix = :id
  end

  ::CustomEnum = Class.new(Enumerations::Base)

  CustomEnum.values draft:      { id: 1, name: 'Draft' },
                    review:     { id: 2, name: 'Review' },
                    published:  { id: 3, name: 'Published', published: true }

  ::CustomModel = Class.new(ActiveRecord::Base)

  CustomModel.enumeration :custom_enum

  Enumerations.restore_default_configuration
end
