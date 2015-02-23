require File.expand_path("../../test_helper", __FILE__)

class SassTumblrTest < Test::Unit::TestCase
  TestCases = {
    :tag_in_selector => [
      "{Tag:Tag} { key: value; }",
      "{Tag:Tag}{key:value}"
    ],
    :tag_in_key => [
      "selector { {Tag:Tag}: value; }",
      "selector{{Tag:Tag}:value}"
    ],
    :tag_in_value => [
      "selector { key: {Tag} ident {Tag:Tag}; }",
      "selector{key:{Tag} ident {Tag:Tag}}"
    ]
  }

  ScssParsers = {
    "parser" => Sass::SCSS::Parser,
    "static_parser" => Sass::SCSS::StaticParser,
    "css_parser" => Sass::SCSS::CssParser
  }

  TestCases.each do |test_name, (css, expected)|
      ScssParsers.each do |parser_name, parser_class|
      define_method :"test_#{parser_name}_with_#{test_name}" do
        parser = parser_class.new(css, "test", 1)

        node = nil
        assert_nothing_raised do
          node = parser.parse
        end

        node.options = {:style => :compressed}
        assert_equal expected, node.render.strip
      end
    end
  end

  [
    #:sass, # NOTE: Old indent format is not supported yet.
    :scss
  ].each do |syntax|
    TestCases.each do |test_name, (css, expected)|
      define_method :"test_#{syntax}_engine_with_#{test_name}" do
        engine = Sass::Engine.new(css, :syntax => syntax, :style => :compressed)

        result = nil
        assert_nothing_raised do
          result = engine.render
        end

        assert_equal expected, result.strip
      end
    end
  end
end

