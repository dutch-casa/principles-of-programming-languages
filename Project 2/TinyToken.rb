#
#  Class Token - Encapsulates the tokens in TINY
#
#   @type - the type of token (Category)
#   @text - the text the token represents (Lexeme)
#
class Token
	attr_accessor :type
	attr_accessor :text

# This is the only part of this class that you need to
# modify.
	EOF = "eof"
	LPAREN = "("
	RPAREN = ")"
	ADDOP  = "+"
	SUBOP = "-" #ADDED BY ME
	MULTOP = "*" #ADDED BY ME
	DIVOP = "/" #ADDED BY ME
	PRINT = "print" #ADDED BY ME
	INT = "int" #ADDED BY ME
	EQUAL = "=" #ADDED BY ME
	ID = "id" #ADDED BY ME
	WS = "whitespace"
    UNKWN = "unknown"



#constructor
	def initialize(type,text)
		@type = type
		@text = text
	end

	def get_type
		return @type
	end

	def get_text
		return @text
	end

# to string method
	def to_s
		return "#{@type} #{@text}"
	end
end
