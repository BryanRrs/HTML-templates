class ForTag
    def initialize(forDesc, nodes)
        @forDesc = forDesc
        @nodes = nodes
    end

    def render(context)
        # pp context
        # pp @forDesc[-1]
        retVal = context_lookup(context, @forDesc[-1] )
        # pp retVal
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
end