require 'i18n'

I18n.available_locales = [:en, :hr, :fr]
I18n.load_path = Dir[File.join('test', 'locales', '*.yml')]
