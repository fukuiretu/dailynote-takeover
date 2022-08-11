require 'tempfile'

module Dailynote
	class Make
		def initialize(file_path)
			@file_path = file_path
			@today = Time.now
		end

		def call
			tf = Tempfile.open('tmp') do |fp|
				fp.puts metadata

				takeover_content.each do |v| 
					fp.puts v
				end

				fp.puts memo
				
				fp
			end

			puts File.read(tf.path)
		end

		def self.call(file_path)
			self.new(file_path).call
		end

		private
		
		def metadata
			[
				'---',
				"aliases: [#{@today.strftime('%Y/%m/%d')},#{@today.strftime('%Y年%m月%d日')}]",
				"tags: [#{@today.strftime('%Y/%m/%d')},#{@today.strftime('%Y/%m')}]",
				'---'
			].join("\n")
		end

		def takeover_content
			result = ["# #{@today.strftime('%Y-%m-%d')}やること"]

			is_takeover_area = false
			
			File.foreach(@file_path) do |line|
				if line.strip.end_with?('やること')
					is_takeover_area = true
					next
				end
				next if line.strip.start_with?('- [x]')
				break if line.strip.end_with?('日誌')
				next unless is_takeover_area

				result << line
			end

			result
		end

		def memo
			[
				"# #{@today.strftime('%Y-%m-%d')}覚書",
				'- '
			].join("\n")
		end
	end
end
