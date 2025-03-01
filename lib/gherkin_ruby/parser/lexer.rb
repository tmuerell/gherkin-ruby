#--
# DO NOT MODIFY!!!!
# This file is automatically generated by rex 1.0.7
# from lexical definition file "gherkin.rex".
#++

require 'racc/parser'
# Compile with: rex gherkin.rex -o lexer.rb

class GherkinRuby::Parser < Racc::Parser
      require 'strscan'

      class ScanError < StandardError ; end

      attr_reader   :lineno
      attr_reader   :filename
      attr_accessor :state

      def scan_setup(str)
        @ss = StringScanner.new(str)
        @lineno =  1
        @state  = nil
      end

      def action
        yield
      end

      def scan_str(str)
        scan_setup(str)
        do_parse
      end
      alias :scan :scan_str

      def load_file( filename )
        @filename = filename
        File.open(filename, "r") do |f|
          scan_setup(f.read)
        end
      end

      def scan_file( filename )
        load_file(filename)
        do_parse
      end


        def next_token
          return if @ss.eos?

          # skips empty actions
          until token = _next_token or @ss.eos?; end
          token
        end

        def _next_token
          text = @ss.peek(1)
          @lineno  +=  1  if text == "\n"
          token = case @state
            when nil
          case
                  when (text = @ss.scan(/[ \t]+/))
                    ;

                  when (text = @ss.scan(/\#.*$/))
                    ;

                  when (text = @ss.scan(/\n/))
                     action { [:NEWLINE, text] }

                  when (text = @ss.scan(/Feature:/))
                     action { [:FEATURE, text[0..-2]] }

                  when (text = @ss.scan(/Background:/))
                     action { [:BACKGROUND, text[0..-2]] }

                  when (text = @ss.scan(/Scenario:/))
                     action { [:SCENARIO, text[0..-2]] }

                  when (text = @ss.scan(/@(\w|-|:)+/))
                     action { [:TAG, text[1..-1]] }

                  when (text = @ss.scan(/Given/))
                     action { [:GIVEN, text] }

                  when (text = @ss.scan(/When/))
                     action { [:WHEN, text] }

                  when (text = @ss.scan(/Then/))
                     action { [:THEN, text] }

                  when (text = @ss.scan(/And/))
                     action { [:AND, text] }

                  when (text = @ss.scan(/But/))
                     action { [:BUT, text] }

                  when (text = @ss.scan(/\*/))
                     action { [:STAR, text] }

                  when (text = @ss.scan(/[^#\n]*/))
                     action { [:TEXT, text.strip] }

          
          else
            text = @ss.string[@ss.pos .. -1]
            raise  ScanError, "can not match: '" + text + "'"
          end  # if

        else
          raise  ScanError, "undefined state: '" + state.to_s + "'"
        end  # case state
          token
        end  # def _next_token

  def tokenize(code)
    scan_setup(code)
    tokens = []
    while token = next_token
      tokens << token
    end
    tokens
  end
end # class
