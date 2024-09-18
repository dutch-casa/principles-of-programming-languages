#
#  Class Lexer - Reads a TINY program and emits tokens
#
class Lexer
# Constructor - Is passed a file to scan and outputs a token
#               each time nextToken() is invoked.
#   @c        - A one character lookahead
	def initialize(filename)
		begin
			@f = File.open(filename,'r:utf-8')
		rescue Errno::ENOENT
			puts "Error: File '#{filename}' not found."
			return
		end

		# Go ahead and read in the first character in the source
		# code file (if there is one) so that you can begin
		# lexing the source code file
		if (! @f.eof?)
			@c = @f.getc()
		else
			@c = "eof"
			@f.close()
		end
	end

	# Method nextCh() returns the next character in the file
	def nextCh()
		if (! @f.eof?)
			@c = @f.getc()
		else
			@c = "eof"
		end

		return @c
	end

	# Method nextToken() reads characters in the file and returns
	# the next token
	def nextToken()
		if @c == "eof"
			tok = Token.new(Token::EOF,"eof")

		elsif (whitespace?(@c))
			str =""

			while whitespace?(@c)
				str += @c
				nextCh()
			end
			tok = Token.new(Token::WS,str)
		elsif(numeric?(@c))
			str = ""
			while numeric?(@c)
				str += @c
				nextCh()
			end
			tok = Token.new(Token::INT,str)
		elsif(numeric?(@c))
			str = ""
			while(numeric?(@c))
				str += @c
				nextCh()
			end
			tok = Token.new(Token::INT,str)

		elsif(letter?(@c))
			str = ""
			while(letter?(@c))
				str += @c
				nextCh()
			end

			if str == "print"
				tok = Token.new(Token::PRINT,str)
			else
				tok = Token.new(Token::ID,str)
			end

		else
			case @c
			when "+"
				tok = Token.new(Token::ADOP, @c)


			when "="
				tok = Token.new(Token::EQUAL, @c)

			when "-"
				tok = Token.new(Token::SUBOP, @c)

			when "*"
				tok = Token.new(Token::MULTOP, @c)

			when "/"
				tok = Token.new(Token::DIVOP, @c)

			when "("
				tok = Token.new(Token::LPAREN, @c)

			when ")"
				tok = Token.new(Token::RPAREN, @c)
			else
				tok = Token.new(Token::UNKWN, @c)
			end
			nextCh()
		end
		puts "Next token is: #{tok.type} Next lexeme is: #{tok.text}"
		return tok
		end

end
#
# Helper methods for Scanner
#
def letter?(lookAhead)
	lookAhead =~ /^[a-z]|[A-Z]$/
end

def numeric?(lookAhead)
	lookAhead =~ /^(\d)+$/
end

def whitespace?(lookAhead)
	lookAhead =~ /^(\s)+$/
end
