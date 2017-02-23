# Master

### Fixed

* added procces_option to the Element API
### Internal
* element#options now includes both elements and html attributes
* elements#attributes only includes html attributes and can't be mutated. Change element#options instead
* elements#normalize_options no longer tries to use the default value if an option is present

# v0.2.1 2016-09-29

### Fixed

* Correctly require declarative heritage for Formular::Element::Module - (@fran-worley)
* Update readme & include example gemgem links - (@fran-worley)


# v0.2.0 2016-09-27

First public release