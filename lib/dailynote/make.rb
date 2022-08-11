module Dailynote
	class Make
		def initialize(file)
			@file = file
		end

		def call
		end

		def self.call(file)
			self.new(file).call
		end
	end
end