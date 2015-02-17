require File.expand_path("../../test_helper", __FILE__)

class SassTumblrTest < Test::Unit::TestCase
  {
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
  }.each do |test_name, (css, expected)|
    [
      Sass::SCSS::Parser,
      Sass::SCSS::StaticParser,
      Sass::SCSS::CssParser
    ].each do |parser_class|
      define_method :"test_#{parser_class.name}_with_#{test_name}" do
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
end

