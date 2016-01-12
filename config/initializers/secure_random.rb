module SecureRandom
	BASE58_ALPHABET	=	('0'..'9').to_a + ('A'..'Z').to_a + ('a'..'z').to_a - ['0', 'O', 'I', 'l']
#	BASE34LOW_ALPHABET	=	('0'..'9').to_a + ('a'..'z').to_a - ['0', 'l']
	
	def self.base58(n = 16)
	  SecureRandom.random_bytes(n).unpack("C*").map do |byte|
	    idx = byte % 64
	    idx = SecureRandom.random_number(58) if idx >= 58
	    BASE58_ALPHABET[idx]
	  end.join
	end
	def self.base34(n = 24)
		self.base58(n).downcase
	end
end
