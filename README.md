# rake js:routes

[![Gem](https://img.shields.io/gem/v/js_rails_routes.svg?maxAge=2592000)](https://rubygems.org/gems/js_rails_routes)
![Build Status](https://github.com/increments/js_rails_routes/actions/workflows/test.yml/badge.svg?branch=master)
[![Code Climate](https://codeclimate.com/github/increments/js_rails_routes/badges/gpa.svg)](https://codeclimate.com/github/increments/js_rails_routes)
[![Test Coverage](https://codeclimate.com/github/increments/js_rails_routes/badges/coverage.svg)](https://codeclimate.com/github/increments/js_rails_routes/coverage)
[![license](https://img.shields.io/github/license/increments/js_rails_routes.svg?maxAge=2592000)](https://github.com/increments/js_rails_routes/blob/master/LICENSE)

Generate a ES6 module that contains Rails routes.

## Description

This gem provides "js:routes" rake task.
It generates a ES6 requirable module which exports url helper functions defined in your Rails application.

Suppose the app has following routes:

```rb
# == Route Map
#
#       Prefix Verb   URI Pattern                  Controller#Action
#     articles GET    /articles(.:format)          articles#index
#              POST   /articles(.:format)          articles#create
#  new_article GET    /articles/new(.:format)      articles#new
# edit_article GET    /articles/:id/edit(.:format) articles#edit
#      article GET    /articles/:id(.:format)      articles#show
#              PATCH  /articles/:id(.:format)      articles#update
#              PUT    /articles/:id(.:format)      articles#update
#              DELETE /articles/:id(.:format)      articles#destroy
Rails.application.routes.draw do
  resources :articles
end
```

then `rake js:routes` generates "app/assets/javascripts/rails-routes.js" as:

```js
// Don't edit manually. `rake js:routes` generates this file.
function process(route, params, keys) {
  var query = [];
  for (var param in params) if (params.hasOwnProperty(param)) {
    if (keys.indexOf(param) === -1) {
      query.push(param + "=" + encodeURIComponent(params[param]));
    }
  }
  return query.length ? route + "?" + query.join("&") : route;
}

export function article_path(params) { return process('/articles/' + params.id + '', params, ['id']); }
export function articles_path(params) { return process('/articles', params, []); }
export function edit_article_path(params) { return process('/articles/' + params.id + '/edit', params, ['id']); }
export function new_article_path(params) { return process('/articles/new', params, []); }
```

## VS.

[railsware/js-routes](https://github.com/railsware/js-routes) spreads url helpers via global variable.

This gem uses ES6 modules.

## Requirement

- Rails >= 3.2

## Usage

Generate routes file.

```bash
rake js:routes
```

### Configuration

JSRailsRoutes supports several parameters:

Name               | Type      | Description                                                                           | Default
-------------------|-----------|---------------------------------------------------------------------------------------|----------------------------------------
`include_paths`    | `Regexp`  | Paths match to the regexp are included                                                | `/.*/`
`exclude_paths`    | `Regexp`  | Paths match to the regexp are excluded                                                | `/^$/`
`include_names`    | `Regexp`  | Names match to the regexp are included                                                | `/.*/`
`exclude_names`    | `Regexp`  | Names match to the regexp are excluded                                                | `/^$/`
`exclude_engines`  | `Regexp`  | Rails engines match to the regexp are excluded                                        | `/^$/`
`output_dir`       | `String`  | Output JS file into the specified directory                                           | `Rails.root.join("app", "assets", "javascripts")`
`camelize`         | `Symbol`  | Output JS file with chosen camelcase type it also avaliable for `:lower` and `:upper` | `nil`
`target`           | `String`  | Target type. `"js"` or `"ts"`                                                         | `"js"`
`route_filter`     | `Proc`    | Fully customizable filter on `JSRails::Route`                                         | `->(route) { true }`
`route_set_filter` | `Proc`    | Fully customizable filter on `JSRails::RouteSet`                                      | `->(route_set) { true }`

You can configure via `JSRailsRoutes.configure`.

```rb
# Rakefile
JSRailsRoutes.configure do |c|
  c.exclude_paths = %r{^/(rails|sidekiq)}
  c.output_dir = Rails.root.join('client/javascripts')
end
```

Now `rake js:routes` ignores paths starting with "/rails" or "/sidekiq".

### Command line parameters

You can override the coniguration via command line parameters:

```bash
rake js:routes exclude_paths='^/rails'
```

The command still ignores "/rails" but includes "/sidekiq".

### Rename route

You can rename route in `route_filter`:

```rb
# Rakefile
JSRailsRoutes.configure do |c|
  c.route_filter = -> (route) do
    # Remove common prefix if route's name starts with it.
    route.name = route.name[4..-1] if route.name.start_with?('foo_')
    true
  end
end
```

## Install

Your Rails Gemfile:

```rb
gem 'js_rails_routes', group: :development
```

## License

[MIT](https://github.com/increments/js_rails_routes/blob/master/LICENSE)
