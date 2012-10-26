Gem::Specification.new do |s|
  s.name        = 'ruby_socket_server'
  s.version     = '0.0.1'
  s.date        = '2012-10-25'
  s.summary     = "Ruby socket server for chat"
  s.description = "Ruby socket server for chat"
  s.authors     = ["myksb1223"]
  s.email       = 'myksb1223@plokia.com'
  s.files	= ["lib/ruby_socket_server.rb", "lib/ruby_socket_server/server.rb", "lib/ruby_socket_server/client.rb", "lib/generators/ruby_socket_server_generator.rb", "lib/generators/templates/create_users.rb", "lib/generators/templates/create_friend_chats.rb", "lib/generators/templates/create_servers.rb", "lib/generators/templates/user.rb", "lib/generators/templates/server.rb", "lib/generators/templates/friend_chat.rb", "lib/generators/templates/start_server.rb"]
  s.require_paths = ["lib"]
  s.executables = ["ruby_socket_server"]
  s.homepage    = 'https://github.com/myksb1223/ruby_socket_server'
end
