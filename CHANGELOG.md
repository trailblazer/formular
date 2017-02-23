# Master

### Fixed

* Select elements prompt and include_blank options now operate the same way as simple form
* added procces_option to the Element API
* Escape html (controls, labels errors hints)
* provide an element module for easily escaping html values
* setting a default builder in the helper now actually works!

### Internal

* element#options now includes both elements and html attributes
* elements#attributes only includes html attributes and can't be mutated. Change element#options instead
* elements#normalize_options no longer tries to use the default value if an option is present
* added a module for html_escape
* renamed WrappedControl module to Wrapped and stopped including control
* changes the order of default_hash to better respect inheritance ordering

# v0.2.1 2016-09-29

### Fixed

* Correctly require declarative heritage for Formular::Element::Module - (@fran-worley)
* Update readme & include example gemgem links - (@fran-worley)

# v0.2.0 2016-09-27

First public release