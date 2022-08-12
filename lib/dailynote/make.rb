require 'tempfile'
require 'date'

module Dailynote
  class Make
    attr_reader :dailynote_dir, :today, :yesterday_dailynote_path

    METADATA_ENDLINE = 6

    def initialize(dailynote_dir)
      @dailynote_dir = dailynote_dir
      @today = Time.now
    end

    def call
      tf = Tempfile.open('tmp') do |fp|
        fp.puts metadata
        takeover_content.each { |v| fp.puts v } 
        fp.puts "---\n"
        fp.puts memo
        
        fp
      end

      puts File.read(tf.path)

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
        "\n"
      ].join("\n")
    end

    def takeover_content
      result = ["# #{@today.strftime('%Y-%m-%d')} やること"]

      i = 0
      File.foreach(yesterday_dailynote_path) do |line|
        i = i.succ
        
        next if i < METADATA_ENDLINE
        next if line.strip.end_with?('やること')
        next if line.strip.start_with?('- [x]')
        break if line.strip.start_with?('---')

        result << line
      end

      result
    end

    def memo
      [
        "# #{@today.strftime('%Y-%m-%d')} 覚書",
        '- '
      ].join("\n")
    end
  end
end
