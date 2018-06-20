require 'webrick'

# Simplistic server that just serves the root of where it's at.
# Meant for static website debugging

root = File.expand_path(File.dirname(__FILE__))
server = WEBrick::HTTPServer.new :Port => 8000, :DocumentRoot => root
trap 'INT' do server.shutdown end

server.start
