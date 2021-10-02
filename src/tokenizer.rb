require 'pp'

$smart_re = /((?:[^\s'"]*(?:(?:"(?:[^"\\]|\\.)*" | '(?:[^'\\]|\\.)*')[^\s'"]*)+) | \S+)/
$token_enum = {:TEXT => 0, :VAR => 1, :BLOCK => 2}
$token_syntax = {
                :VARIABLE_ATTRIBUTE_SEPARATOR => '.',
                :BLOCK_TAG_START => '{%',
                :BLOCK_TAG_END => '%}',
                :VARIABLE_TAG_START => '{{',
                :VARIABLE_TAG_END => '}}',
                :COMMENT_TAG_START => '{#',
                :COMMENT_TAG_END => '#}',
                :SINGLE_BRACE_START => '{',
                :SINGLE_BRACE_END => '}'
                }

class Token
    attr_accessor :token_type
    attr_accessor :contents
    def initialize(token_type, contents, position, lineno)
        @token_type = token_type
        @contents = contents
        @position = position
        @lineno = lineno
    end

    def split_contents
        return @contents.split(smart_re)
    end

end


class Tokenizer

    def initialize(template)
        @template = template
        @tag_re = /({%.*?%}|{{.*?}}|{#.*?#})/ 
    end

    def tokenize
        in_tag = false
        result = []
        lineno = 1
        for s in @template.split(@tag_re)
            if not s.empty?
                result.append(createToken(s, nil, lineno, in_tag))
                lineno += s.scan(/\n/).size
            end
            in_tag = !in_tag
        end
        result
    end
    
    def createToken(str, position, lineno, in_tag)
        if in_tag
            str_start = str[0...2]
            content = str[2...-2].strip
            case str_start
            when $token_syntax[:BLOCK_TAG_START]
                return Token.new($token_enum[:BLOCK], content, position, lineno)
            when $token_syntax[:VARIABLE_TAG_START]
                return Token.new($token_enum[:VAR], content, position, lineno)
            end
        end
        Token.new($token_enum[:TEXT], str, position, lineno)
    end

end

# f = open('../test-files/clean.html').read

# t = Tokenizer.new(f)
# pp t.tokenize