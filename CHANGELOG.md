# Change Log

## [v2.5.3](https://github.com/infinum/enumerations/tree/v2.5.3) (2022-01-27)
[Full Changelog](https://github.com/infinum/enumerations/compare/v2.5.2...v2.5.3)

**Fixed bugs:**

- Prevent `method_missing` instantiates new instance of `Enumerations::Base`; returns `String` instead

**Merged pull requests:**

- Initialize `ActiveSupport::Multibyte::Chars` with a String [\#58](https://github.com/infinum/enumerations/pull/58) ([PetarCurkovic](https://github.com/PetarCurkovic))

## [v2.5.2](https://github.com/infinum/enumerations/tree/v2.5.2) (2022-01-27)
[Full Changelog](https://github.com/infinum/enumerations/compare/v2.5.1...v2.5.2)

**Implemented enhancements:**

- Adds Ruby 3.1 to test suite. Changes the runner to ubuntu-latest.

**Closed issues:**

- Ruby 3.0, `respond_to? :name` always returns true [\#55](https://github.com/infinum/enumerations/issues/55)

**Merged pull requests:**

- Initialize `ActiveSupport::Multibyte::Chars` with a String [\#56](https://github.com/infinum/enumerations/pull/56) ([lovro-bikic](https://github.com/lovro-bikic))
- Test against Ruby 3.1 [\#57](https://github.com/infinum/enumerations/pull/57) ([lovro-bikic](https://github.com/lovro-bikic))

## [v2.5.1](https://github.com/infinum/enumerations/tree/v2.5.1) (2021-05-24)
[Full Changelog](https://github.com/infinum/enumerations/compare/v2.5.0...v2.5.1)

**Implemented enhancements:**

- Add support for Ruby 3 [\#52](https://github.com/infinum/enumerations/issues/52)

## [v2.5.0](https://github.com/infinum/enumerations/tree/v2.5.0) (2021-03-03)
[Full Changelog](https://github.com/infinum/enumerations/compare/v2.4.0...v2.5.0)

**Implemented enhancements:**

- Add `raise_invalid_value_error` configuration option to disable raising errors on invalid values

## [v2.4.0](https://github.com/infinum/enumerations/tree/v2.4.0) (2019-02-07)
[Full Changelog](https://github.com/infinum/enumerations/compare/v2.3.3...v2.4.0)

**Implemented enhancements:**

- Add `translate_attributes` configuration option to disable translation of attributes

## [v2.3.3](https://github.com/infinum/enumerations/tree/v2.3.1) (2019-19-09)
[Full Changelog](https://github.com/infinum/enumerations/compare/v2.3.2...v2.3.3)

## [v2.3.2](https://github.com/infinum/enumerations/tree/v2.3.1) (2019-03-27)
[Full Changelog](https://github.com/infinum/enumerations/compare/v2.3.1...v2.3.2)

## [v2.3.1](https://github.com/infinum/enumerations/tree/v2.3.1) (2017-09-08)
[Full Changelog](https://github.com/infinum/enumerations/compare/v2.3.0...v2.3.1)

## [v2.3.0](https://github.com/infinum/enumerations/tree/v2.3.0) (2017-09-08)
[Full Changelog](https://github.com/infinum/enumerations/compare/v2.2.3...v2.3.0)

**Implemented enhancements:**

- Setting attribute to nil if enumeration value is unknown - surprising? [\#35](https://github.com/infinum/enumerations/issues/35)
- Add `without` methods [\#31](https://github.com/infinum/enumerations/issues/31)
- Add methods with '?' [\#19](https://github.com/infinum/enumerations/issues/19)
- Add with\_enumeration\(enumeration\) scope [\#18](https://github.com/infinum/enumerations/issues/18)

**Closed issues:**

- Not assigning the enumeration when tweaking the primary and foreign key [\#32](https://github.com/infinum/enumerations/issues/32)
- Undocumented feature - can't set attribute if it's not in the enumeration [\#30](https://github.com/infinum/enumerations/issues/30)

**Merged pull requests:**

- Feature/raising error on invalid enumeration value [\#38](https://github.com/infinum/enumerations/pull/38) ([PetarCurkovic](https://github.com/PetarCurkovic))
- Bugfix/config options [\#37](https://github.com/infinum/enumerations/pull/37) ([PetarCurkovic](https://github.com/PetarCurkovic))
- Feature/predicate methods for attributes [\#36](https://github.com/infinum/enumerations/pull/36) ([PetarCurkovic](https://github.com/PetarCurkovic))
- Feature/without scopes [\#34](https://github.com/infinum/enumerations/pull/34) ([PetarCurkovic](https://github.com/PetarCurkovic))
- Feature/with enumeration scope [\#33](https://github.com/infinum/enumerations/pull/33) ([PetarCurkovic](https://github.com/PetarCurkovic))

## [v2.2.3](https://github.com/infinum/enumerations/tree/v2.2.3) (2017-03-17)
[Full Changelog](https://github.com/infinum/enumerations/compare/v2.2.2...v2.2.3)

## [v2.2.2](https://github.com/infinum/enumerations/tree/v2.2.2) (2017-03-01)
[Full Changelog](https://github.com/infinum/enumerations/compare/v2.2.1...v2.2.2)

**Implemented enhancements:**

- Add id and quoted\_id methods [\#20](https://github.com/infinum/enumerations/issues/20)

**Fixed bugs:**

- Error when assiging nil [\#21](https://github.com/infinum/enumerations/issues/21)

**Closed issues:**

- upgrade to new codeclimate reporter [\#25](https://github.com/infinum/enumerations/issues/25)
- Giving a invalid enum name raises an error [\#23](https://github.com/infinum/enumerations/issues/23)
- Make second argument to Enumerations.value optional [\#22](https://github.com/infinum/enumerations/issues/22)

**Merged pull requests:**

- Make second argument to Enumerations.value optional [\#28](https://github.com/infinum/enumerations/pull/28) ([domagojnakic](https://github.com/domagojnakic))
- Fix giving invalid enum name raises error [\#27](https://github.com/infinum/enumerations/pull/27) ([domagojnakic](https://github.com/domagojnakic))
- Replaced CodeClimate::TestReporter with SimpleCov [\#26](https://github.com/infinum/enumerations/pull/26) ([PetarCurkovic](https://github.com/PetarCurkovic))
- Add migration readme [\#24](https://github.com/infinum/enumerations/pull/24) ([Narayanan170](https://github.com/Narayanan170))

## [v2.2.1](https://github.com/infinum/enumerations/tree/v2.2.1) (2016-09-20)
[Full Changelog](https://github.com/infinum/enumerations/compare/v2.2.0...v2.2.1)

**Closed issues:**

- Add option to store foreign\_key as string [\#14](https://github.com/infinum/enumerations/issues/14)

**Merged pull requests:**

- Bugfix/empty initializer [\#17](https://github.com/infinum/enumerations/pull/17) ([PetarCurkovic](https://github.com/PetarCurkovic))

## [v2.2.0](https://github.com/infinum/enumerations/tree/v2.2.0) (2016-09-19)
[Full Changelog](https://github.com/infinum/enumerations/compare/v2.1.0...v2.2.0)

**Merged pull requests:**

- Feature/remove [\#16](https://github.com/infinum/enumerations/pull/16) ([PetarCurkovic](https://github.com/PetarCurkovic))

## [v2.1.0](https://github.com/infinum/enumerations/tree/v2.1.0) (2016-08-19)
[Full Changelog](https://github.com/infinum/enumerations/compare/v2.0.0...v2.1.0)

**Closed issues:**

- Moved all back to Base [\#9](https://github.com/infinum/enumerations/issues/9)
- I18n.locale [\#6](https://github.com/infinum/enumerations/issues/6)
- Case statement [\#3](https://github.com/infinum/enumerations/issues/3)

**Merged pull requests:**

- Feature/where filtering [\#13](https://github.com/infinum/enumerations/pull/13) ([PetarCurkovic](https://github.com/PetarCurkovic))
- Feature/localized attributes [\#12](https://github.com/infinum/enumerations/pull/12) ([PetarCurkovic](https://github.com/PetarCurkovic))

## [v2.0.0](https://github.com/infinum/enumerations/tree/v2.0.0) (2016-08-17)
[Full Changelog](https://github.com/infinum/enumerations/compare/v1.3.0...v2.0.0)

**Merged pull requests:**

- Update version to 2.0.0 [\#11](https://github.com/infinum/enumerations/pull/11) ([PetarCurkovic](https://github.com/PetarCurkovic))
- Refactor [\#10](https://github.com/infinum/enumerations/pull/10) ([PetarCurkovic](https://github.com/PetarCurkovic))

## [v1.3.0](https://github.com/infinum/enumerations/tree/v1.3.0) (2016-08-11)
[Full Changelog](https://github.com/infinum/enumerations/compare/v1.1.1...v1.3.0)

## [v1.1.1](https://github.com/infinum/enumerations/tree/v1.1.1) (2016-06-07)
[Full Changelog](https://github.com/infinum/enumerations/compare/v1.1.0...v1.1.1)

**Merged pull requests:**

- Bugfix/value-id [\#8](https://github.com/infinum/enumerations/pull/8) ([nikajukic](https://github.com/nikajukic))
- Document configuration options [\#7](https://github.com/infinum/enumerations/pull/7) ([stankec](https://github.com/stankec))
- Refactoring all around [\#5](https://github.com/infinum/enumerations/pull/5) ([janvarljen](https://github.com/janvarljen))
- Added value method and support for custom attributes [\#4](https://github.com/infinum/enumerations/pull/4) ([PetarCurkovic](https://github.com/PetarCurkovic))
- Some refactoring and updated README [\#2](https://github.com/infinum/enumerations/pull/2) ([PetarCurkovic](https://github.com/PetarCurkovic))

## [v1.1.0](https://github.com/infinum/enumerations/tree/v1.1.0) (2012-08-19)
**Merged pull requests:**

- Gemspec. [\#1](https://github.com/infinum/enumerations/pull/1) ([neektza](https://github.com/neektza))
