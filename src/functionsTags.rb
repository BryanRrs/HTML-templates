class ForTag
    def initialize(forDesc, nodes)
        @forDesc = forDesc
        @nodes = nodes
    end

    def render(context)
        retVal = context_lookup(context, @forDesc[-1] )
        if retVal.nil?
            return ''
        else
            for e in retVal
                context[@forDesc[0]] = e
                @nodes.renderPage(context)
            end
            return nil
        end
    end

    def context_lookup(context, var)
        splited = var.split('.')
        retVal = context
        for s in splited
            retVal = retVal[s]
        end
        return retVal
    end
end

class IfTag
    def initialize(condition, nodes)
        @condition = condition
        @nodes = nodes
    end

    def render(context)
        r = false 
        case @condition.size
        when 1
            v = var_resolver(context, @condition[0])
            if not v.nil?
                r = v
            end
        when 3
            v1 = var_resolver(context, @condition[0])
            v2 = var_resolver(context, @condition[2])
            if not v1.nil? and not v2.nil?
                r = boolean_solver(v1, v2, @condition[1])
            end
        end
        if r
            @nodes.renderPage(context)
        end
        return nil
    end

    def var_resolver(context, var)
        begin
            val = Integer(var)
        rescue ArgumentError
            pp var
            if var.downcase == 'false'
                val = false
            elsif var.downcase == 'true'
                val = true
            else
                splited = var.split('.')
                val = context
                for s in splited
                    val = val[s]
                end
            end
        end
        return val
    end

    def boolean_solver(v1, v2, cond)
        v = false
        begin
            case cond
            when '<'
                v = v1 < v2
            when '<='
                v = v1 <= v2
            when '>'
                v = v1 > v2
            when '>='
                v = v1 >= v2
            when '=='
                v = v1 == v2
            end
        rescue ArgumentError
            return v
        end
    end
end