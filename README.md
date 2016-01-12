# Formular

_Framework-Agnostic Form Renderer for Ruby._

## Overview

Formular renders HTML forms in a similar fashion to [SimpleForm](https://github.com/plataformatec/simple_form) and other gems. It is lightning-fast, has zero coupling to any ORM or web framework, and makes no magical assumptions about the rendered form object.

It works best if backed with a form object like [Reform](https://github.com/apotonick/reform).

Formular's rendering is easily customizable. It provides support for Foundation 5, Foundation 6, Bootstrap 3, and ... # TODO.

## Example

## API

The render API is highly inspired by the [SimpleForm](https://github.com/plataformatec/simple_form) gem.

## Key Features

* Incredibly fast.
* Customization: "Wrappers" are self-explaining objects. Ships with renderers for Foundation, ...
* No magic. No `respond_to?`, no guessing, no hidden semantics.
* A well-designed API instead of a configuration DSL. If you need to change behavior, program it.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'formular'
```

Requires Ruby >= 2.1.



## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

