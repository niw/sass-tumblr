require "sass"

module Sass
  module SCSS
    module RX
      # Pattern to match Tumblr tag.
      TUMBLR_VAR = /({[a-zA-Z0-9_]+(?::[a-zA-Z0-9_]+)?})/
    end

    # See lib/sass/scss/static_parser.rb
    class StaticParser
      # Handle Tumblr variable tags in CSS selector
      # Used from CssParser directly, from StaticParser and Parser via RuleNode#try_to_parse_non_interpolated_rules.
      alias :qualified_name_without_tumblr :qualified_name
      def qualified_name(allow_star_name = false)
        if var = tok(TUMBLR_VAR)
          return nil, var
        else
          qualified_name_without_tumblr(allow_star_name)
        end
      end

      # Handle Tumblr variable tags in CSS key
      # Used from CssParser and StaticParser
      # This is needed even we've patched in Parser class since it's also overridden in StaticParser.
      alias :interp_ident_without_tumblr :interp_ident
      def interp_ident(ident = IDENT)
        if var = tok(TUMBLR_VAR)
          [var]
        else
          interp_ident_without_tumblr(ident)
        end
      end
    end

    # See lib/sass/scss/parser.rb
    class Parser
      # Handle Tumblr variable tags in CSS selector
      # Used from StaticParser and Parser.
      alias :almost_any_value_token_without_tumblr :almost_any_value_token
      def almost_any_value_token
        tok(TUMBLR_VAR) || almost_any_value_token_without_tumblr
      end

      # Handle Tumblr variable tags in CSS key
      # Used from StaticParser and Parser.
      alias :interp_ident_without_tumblr :interp_ident
      def interp_ident(ident = IDENT)
        if var = tok(TUMBLR_VAR)
          [var]
        else
          interp_ident_without_tumblr(ident)
        end
      end

      # Avoid to parse first "{" as a block in declaration for Tumblr variable tags in CSS value
      # Used from all parsers.
      alias :value_without_tumblr! :value!
      def value!
        if var = tok?(TUMBLR_VAR)
          sass_script(:parse)
        else
          value_without_tumblr!
        end
      end
    end
  end

  # See lib/sass/script/lexer.rb
  module Script
    class Lexer
      # Handle Tumblr variable tags in CSS value
      # Parse as ident token (like `middle', `top') in the parser.
      # Used from all parsers.
      alias :ident_without_tumblr_var :ident
      def ident
        if scan(TUMBLR_VAR)
          [:ident, @scanner[1]]
        else
          ident_without_tumblr_var
        end
      end
    end
  end
end
