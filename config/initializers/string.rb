class String
	def nl2br
		#self.gsub('\n','<br />\n').gsub('\r', '<br />\r')
		self.gsub("\n\r","<br>").gsub("\r", "").gsub("\n", "<br />")
#		"qqqq qqqq qqqq"
	end
	def with_br
		self.gsub(ERB::Util::HTML_ESCAPE_REGEXP, ERB::Util::HTML_ESCAPE).nl2br.html_safe
	end
end
