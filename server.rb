require 'webrick'

# Simplistic server that just serves ./output
# Meant for static website debugging

root = File.join(File.expand_path(File.dirname(__FILE__)), "output")
server = WEBrick::HTTPServer.new :Port => 8000, :DocumentRoot => root
trap 'INT' do server.shutdown end

server.start
