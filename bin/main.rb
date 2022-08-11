require "json" # Default gem
require "rspec" # Bundled gem

require_relative "../lib/dailynote"
require_relative "../lib/dropbox"

class Main
	def self.call
		Dailynote::Make.call('/Users/fukui.t/Dropbox/Obsidian/c_Daily/2022-08-11.md')

		# Dropbox::Download.call
		# Dropbox::Upload.call
	end
end

Main.call
