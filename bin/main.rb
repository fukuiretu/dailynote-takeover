require "json" # Default gem
require "rspec" # Bundled gem

require_relative "../lib/dailynote"
require_relative "../lib/dropbox"

class Main
  def self.call
    dailynote_dir = ENV['DAILYNOTE_DIR']
    output_path = Dailynote::Make.call(dailynote_dir)

    # TODO: フェーズ2ではGitHub Action越しに実行するのでDropboxのAPI経由に改修予定
    File.write("#{dailynote_dir}/#{Time.now.strftime('%Y-%m-%d')}.md", File.read(output_path))

    # Dropbox::Download.call
    # Dropbox::Upload.call
  end
end

Main.call
