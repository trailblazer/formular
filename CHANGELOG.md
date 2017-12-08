# Master
# v0.2.3 2017-12-08
### Fixed

* Improve Escape html - use for option values and optgroup labels
* Multi Select elements now mark options as selected

# v0.2.2 2017-09-13

### Added

* Select elements prompt and include_blank options now operate the same way as simple form
* added procces_option to the Element API
* Checkboxes now support `checked_value` option as an alias of `value`. Same as SimpleForm.
* you can now set your own builders as the default in the helper

### Fixed

* Escape html (controls, labels errors hints) (fixes #29)
* setting a default builder in the helper now actually works!
* Select elements appends array signifier (`[]`) to element name attribute when `multiple: true` (fixes #40)
* options should always override default values, even when nil. (fixes #39)

### Internal

* element#options now includes both elements and html attributes
* elements#attributes only includes html attributes and can't be mutated. Change element#options instead
* elements#normalize_options no longer tries to use the default value if an option is present
* added a module for html_escape
* renamed WrappedControl module to Wrapped and stopped including control
* changes the order of default_hash to better respect inheritance ordering
* provide an element module for easily escaping html values

# v0.2.1 2016-09-29

### Fixed

* Correctly require declarative heritage for Formular::Element::Module - (@fran-worley)
* Update readme & include example gemgem links - (@fran-worley)

# v0.2.0 2016-09-27

First public release
