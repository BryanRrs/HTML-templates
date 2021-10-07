require_relative 'tokenizer'
require_relative 'functionsTags'
require 'pp'

class Parser
    def initialize(tokens)
        @tokens = tokens
        @tags = {'endfor' => 'for', 'endif' => 'if'}
        @command_stack = []
    end

    def parse
        nodeList = NodeList.new()
        current_command = nil
        command_stack = []
        command_counter = 0
        for token in @tokens
            case token.token_type
            when $token_enum[:TEXT]
                if current_command.nil?
                    nodeList.extend_nodelist(TextNode.new(token))
                else
                    command_stack.push(token)
                end
            when $token_enum[:VAR]
                if current_command.nil?
                    nodeList.extend_nodelist(VarNode.new(token))
                else
                    command_stack.push(token)
                end
            when $token_enum[:BLOCK]
                command = token.contents.split[0]
                if current_command.nil? or command == current_command
                    current_command = command
                    command_counter += 1
                    command_stack.push(token)
                else
                    command_stack.push(token)
                    if @tags[command] == current_command
                        command_counter -= 1
                    end
                end
                if command_counter.equal? 0
                    temp_parser = Parser.new(command_stack[1...-1])
                    block_nodes = temp_parser.parse
                    nodeList.extend_nodelist(BlockNode.new(command_stack[0], block_nodes))
                    command_stack = []
                    current_command = nil
                end
            end
        end
        if current_command == 'else'
            temp_parser = Parser.new(command_stack[1...])
            block_nodes = temp_parser.parse
            nodeList.extend_nodelist(BlockNode.new(command_stack[0], block_nodes))
        end
        return nodeList
    end

    def prepend_token(token)
        @tokens.push(token)
    end
end

class TextNode

    def initialize(token)
        @val = token.contents
        # This is to remove the whitespace generated 
        # where the command blocks {% ... %} would appear
        if @val[-4...] == '    '
            @val = @val.rstrip
        end
    end

    def render(context)
        return @val
    end
end

class VarNode

    def initialize(token)
        @val = token.contents
    end

    def render(context)
        splited = @val.split('.')
        retVal = context
        for s in splited
            retVal = retVal[s]
        end
        return retVal
    end
end

class BlockNode

    attr_accessor :val
    def initialize(token, nodeList)
        @val = token.contents
        @nodeList = nodeList
        blockTag = @val.split(/ /)
        case blockTag[0]
        when 'for'
            @tag = ForTag.new(blockTag[1...], @nodeList)
        when 'if'
            @tag = IfTag.new(blockTag[1...], @nodeList)
        when 'else'
            @tag = ElseTag.new(@nodeList)
        end
    end

    def render(context)
        @tag.render(context)
    end
end

class NodeList

    attr_accessor :nodelist

    def initialize(nodes = [])
        @nodelist = nodes
    end

    def renderPage(context)
        for node in @nodelist
            print node.render(context)
        end
    end

    def extend_nodelist(node)
        @nodelist.push(node)
    end

    def remove_last()
        @nodelist.pop
    end

    def get_subindex(from, to)
        @nodelist[from...to]
    end
end