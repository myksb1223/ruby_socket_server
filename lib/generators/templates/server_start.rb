require 'rubygems'
require 'ruby_socket_server'
load 'config/environment.rb'

server = Server.find(1)
port = server.port
ip_addr = server.ip_addr

socket = RubySocketServer::ServerSocket.new(port, ip_addr)
socket.run
