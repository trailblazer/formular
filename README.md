# Formular

_Framework-Agnostic Form Renderer for Ruby._
[![Build Status](https://travis-ci.org/trailblazer/formular.svg?branch=master)](https://travis-ci.org/trailblazer/formular)
[![Gitter Chat](https://badges.gitter.im/trailblazer/chat.svg)](https://gitter.im/trailblazer/chat)
[![TRB Newsletter](https://img.shields.io/badge/TRB-newsletter-lightgrey.svg)](http://trailblazer.to/newsletter/)


## Overview

Formular renders HTML forms in a similar fashion to [SimpleForm](https://github.com/plataformatec/simple_form) and other gems. It is lightning-fast, has zero coupling to any ORM or web framework, and makes no magical assumptions about the rendered form object.


## Example

While you can instantiate the form builder manually, it's easiest to use the `form` helper to do so. Include `Formular::Helper` or in rails, `Formular::RailsHelper` into your cell, view, or in a Rails controller as a helper.

```ruby
module Post::Cell
  class New < Cell::ViewModel
    include Formular::Helper
```

or

```ruby
class PostsController < ApplicationController
  helper Formular::RailsHelper
```

You should also configure what builder you want to use. This will wrap inputs correctly, and so on.

```ruby
Formular::Helper.builder= :bootstrap3
```

In your view, you're now ready to use Formular's API to render forms.

Our basic builder ships with the following elements:
* error_notification
* form
* fieldset
* legend
* div
* span
* p
* input
* hidden
* label
* error
* hint
* textarea
* submit
* select
* checkbox
* radio
* wrapper
* error_wrapper

We also provide builders for Twitter Bootstrap (v.3&4) and Zurb's Foundation (v.6)

To help you get started we've got some example Sinatra apps so you can see Formular in action:

* [Bootstrap3 (slim)](https://github.com/fran-worley/gemgem-sinatra/blob/formular-slim-bootstrap3/concepts/post/view/new.slim)
* [Bootstrap4 (slim)](https://github.com/fran-worley/gemgem-sinatra/blob/formular-slim-bootstrap4/concepts/post/view/new.slim)
* Foundation6 (slim)

Formular's API docs and information on how to extend it will be found on the [Trailblazer project page](http://trailblazer.to/gems/formular) once the page has been added 😉.

## Key Features

* Incredibly fast.
* Customization: "Wrappers" are self-explaining objects. Ships with renderers for Foundation 6 and Bootstrap 3&4
* No magic, no guessing, no hidden semantics.
* A well-designed API instead of a configuration DSL. If you need to change behavior, program it.

## Limitations

* Nested hashes aren't suffixed with active records `_attributes`.
* Capturing only works with Slim and Hamlit. A 'blockless' API is provided to enable use in ERB but watch this space as improvements are coming for ERB

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'formular'
```

Requires Ruby >= 2.0.0

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
