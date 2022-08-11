require 'tempfile'
require 'date'

module Dailynote
  class Make
    def initialize(dailynote_dir)
      @dailynote_dir = dailynote_dir
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

      tf.path
    end

    def self.call(dailynote_dir)
      self.new(dailynote_dir).call
    end

    private

    def yesterday_dailynote_path
      @yesterday_dailynote_path ||= "#{@dailynote_dir}/#{(Date.today - 1).to_time.strftime('%Y-%m-%d')}.md"
    end

    def metadata
      [
        '---',
        "aliases: [#{@today.strftime('%Y/%m/%d')},#{@today.strftime('%Y年%m月%d日')}]",
        "tags: [#{@today.strftime('%Y/%m/%d')},#{@today.strftime('%Y/%m')}]",
        '---',
        ''
      ].join("\n")
    end

    def takeover_content
      result = ["# #{@today.strftime('%Y-%m-%d')}やること"]

      is_takeover_area = false
      
      p yesterday_dailynote_path
      File.foreach(yesterday_dailynote_path) do |line|
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
