sass-tumblr
===========

Ignore [Tumblr template tags](https://www.tumblr.com/docs/en/custom_themes) like ``a { color: {color:Text}; }`` while parsing SCSS with [Sass](http://sass-lang.com/) gem.
At this moment, old [indent base sass](http://sass-lang.com/documentation/file.INDENTED_SYNTAX.html) is not supported.

Usage
-----

Use [Bundler](http://bundler.io/) and add a dependency to your `Gemfile`.

    $ gem "sass-tumblr"

Then require ``sass_tumblr`` in appropriate way.

    require "sass_tumblr"


Example
-------

Parse SCSS with Tumblr template tags using `rib`.

    $ bundle exec irb
    irb> require "sass_tumblr"
    irb> puts Sass::Engine.new("body {color: {color:Text}}", :syntax => :scss).render
    body {
      color: {color:Text}; }

Limitations
-----------

At this moment, all Tumblr tags in SCSS must be one of next format.
Basically it follows [Tumbler template document](https://www.tumblr.com/docs/en/custom_themes), but not all existing templates are following this rule.

    {CapitalizedTagName}
    {CustomCSS}
    {color:Capitalized Key Name}
    {font:Capitalized Key Name}
    {text:Capitalized Key Name}
    {image:Capitalized Key Name}

Also `{block:KeyName}` and `{/block:KeyName}` may not work.
