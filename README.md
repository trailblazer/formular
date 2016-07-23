# Formular

_Framework-Agnostic Form Renderer for Ruby._
[![Build Status](https://travis-ci.org/trailblazer/formular.svg?branch=master)](https://travis-ci.org/trailblazer/formular)
[![Gitter Chat](https://badges.gitter.im/trailblazer/chat.svg)](https://gitter.im/trailblazer/chat)
[![TRB Newsletter](https://img.shields.io/badge/TRB-newsletter-lightgrey.svg)](http://trailblazer.to/newsletter/)


## Overview

Formular renders HTML forms in a similar fashion to [SimpleForm](https://github.com/plataformatec/simple_form) and other gems. It is lightning-fast, has zero coupling to any ORM or web framework, and makes no magical assumptions about the rendered form object.


## Example

While you can instantiate the form builder manually, it's easiest to use the `form` helper to do so. Include `Formular::Helper` into your cell, view, or in a Rails controller as a helper.

```ruby
module Post::Cell
  class New < Cell::ViewModel
    include Formular::Helper
```

or

```ruby
class PostsController < ApplicationController
  helper Formular::Helper
```

You should also configure what builder you want to use. This will wrap inputs correctly, and so on. 

```ruby
Formular::Helper.builder= :bootstrap3
```

In your view, you're now ready to use Formular's API to render forms.

```slim
= form(model.contract, url) do |f|

  = f.input :title, placeholder: "Title"
  = f.input :url_slug, placeholder: "URL slug"
  .form-group
    = f.checkbox :is_public, label: "Public?"
  .form-group
    = f.radio :owner, label: "Flori", value: 1
    = f.radio :owner, label: "Konsti", value: 2

  .row
    .col-md-2
      = f.radio :owner, collection: [["Flori", 1], ["Konsti", 2]], label: "Owners"
    .col-md-3
      = f.radio :owner, collection: [["Flori", 1], ["Konsti", 2]], label: "Owners, inline", inline: true
    = f.checkbox :roles, collection: [["Admin", 1], ["Owner", 2], ["Maintainer", 3]], checked: model.contract.roles, label: "Roles"

  = f.select :select_roles, collection: [["Admin", 1], ["Owner", 2], ["Maintainer", 3]], selected: model.contract.select_roles, label: "Selectable Roles"

  .form-group
    = f.textarea :content, placeholder: "And your story...", rows: 9
  .form-group
    = f.button type: :submit, value: "Submit!", class: [:btn, :'btn-lg', :'btn-default']
```

Note that a lot of this code can be done automatically by Formular.

## Documentation

Formular's API docs and information on how to extend it can be found on the [Trailblazer project page](http://trailblazer.to/gems/formular).

Formular's rendering is easily customizable. It provides built-in support for Foundation 6 and Bootstrap 3 so far with more to come.

The list of builders provided by default can be seen in the BUILDERS constant. Try the following in an IRB session with your project loaded (rails console).

```ruby
Formular::Helper::BUILDERS
```



## Key Features

* Incredibly fast.
* Customization: "Wrappers" are self-explaining objects. Ships with renderers for Foundation 5 and Bootstrap 3
* No magic. No `respond_to?`, no guessing, no hidden semantics.
* A well-designed API instead of a configuration DSL. If you need to change behavior, program it.

## Limitations

* Currently, nested hashes aren't suffixed with `_attributes`, as it's usually done in ActiveRecord.
* Capturing only works with Slim and Hamlit. A 'blockless' API is provided to enable use in ERB

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'formular'
```

Requires Ruby >= 2.1.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
