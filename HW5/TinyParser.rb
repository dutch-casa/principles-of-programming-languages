#
#  Parser Class
#
load "TinyLexer.rb"
load "TinyToken.rb"
load "AST.rb"

class Parser < Lexer

    def initialize(filename)
        super(filename)
        consume()
    end

    def consume()
        @lookahead = nextToken()
        while(@lookahead.type == Token::WS)
            @lookahead = nextToken()
        end
    end

    def match(dtype)
        case @lookahead.type
        when dtype
            consume()
        else
            puts "Expected #{dtype} found #{@lookahead.text}"
            @errors_found += 1
            consume()
        end
    end

    def program()
        @errors_found = 0

        p = AST.new(Token.new("program","program"))

        while @lookahead.type != Token::EOF
            p.addChild(statement())
        end

        puts "There were #{@errors_found} parse errors found."

        return p
    end

    def statement()
        stmt = AST.new(Token.new("statement","statement"))
        case @lookahead.type
        when Token::PRINT
            stmt = AST.new(@lookahead)
            match(Token::PRINT)
            stmt.addChild(exp())
        else
            stmt = assign()
        end
        return stmt
    end

    def exp()
        start = term()
        case @lookahead.type
        when Token::ADDOP, Token::SUBOP
            et = etail()
            et.addChild(start)
            et.downShift()
        else
            et = start
        end
        return et
    end

    def term()
        start = factor()
        case @lookahead.type
        when Token::MULTOP, Token::DIVOP
            tt = ttail()
            tt.addChild(start)
            tt.downShift()
        else
            tt = start
        end
        return tt
    end

    def factor()
        fct = AST.new(Token.new("factor","factor"))
        case @lookahead.type
        when Token::LPAREN
            match(Token::LPAREN)
            fct = exp()
            if @lookahead.type == Token::RPAREN
                match(Token::RPAREN)
            else
                match(Token::RPAREN)
            end
        when Token::INT
            fct = AST.new(@lookahead)
            match(Token::INT)
        when Token::ID
            fct = AST.new(@lookahead)
            match(Token::ID)
        else
            puts "Expected ( or INT or ID found #{@lookahead.text}"
            @errors_found += 1
            consume()
        end
        return fct
    end

    def ttail()
        tt = AST.new(Token.new("ttail", "ttail"))
        case @lookahead.type
        when Token::MULTOP
            tt = AST.new(@lookahead)
            match(Token::MULTOP)
            tt.setNextSibling(factor())
            rtt = ttail()
            if rtt != nil
                rtt.addChild(tt)
                tt = rtt
            end
        when Token::DIVOP
            tt = AST.new(@lookahead)
            match(Token::DIVOP)
            tt.setNextSibling(factor())
            rtt = ttail()
            if rtt != nil
                rtt.addChild(tt)
                tt = rtt
            end
        else
            return nil
        end
        return tt
    end

    def etail()
        et = AST.new(Token.new("etail", "etail"))
        case @lookahead.type
        when Token::ADDOP
            et = AST.new(@lookahead)
            match(Token::ADDOP)
            et.setNextSibling(term())
            ret = etail()
            if ret != nil
                ret.addChild(et)
                et = ret
            end
        when Token::SUBOP
            et = AST.new(@lookahead)
            match(Token::SUBOP)
            et.setNextSibling(term())
            ret = etail()
            if ret != nil
                ret.addChild(et)
                et = ret
            end
        else
            return nil
        end
        return et
    end

    def assign()
        assgn = AST.new(Token.new("assignment","assignment"))
        case @lookahead.type
        when Token::ID
            idtok = AST.new(@lookahead)
            match(Token::ID)
            case @lookahead.type
            when Token::ASSGN
                assgn = AST.new(@lookahead)
                assgn.addChild(idtok)
                match(Token::ASSGN)
                assgn.addChild(exp())
            else
                match(Token::ASSGN)
            end
        else
            match(Token::ID)
        end
        return assgn
    end
end
