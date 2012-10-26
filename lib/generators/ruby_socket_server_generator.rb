class RubySocketServerGenerator < Rails::Generators::Base
  include Rails::Generators::Migration
  source_root File.expand_path('../templates', __FILE__)

  def self.next_migration_number(path)
    @time ||= Time.now.utc
    @calls ||= -1
    @calls += 1
    (@time + @calls.seconds).strftime("%Y%m%d%H%M%S")
  end

  def copy_migration
    add_ruby_socket_server_migration('create_users')
    add_ruby_socket_server_migration('create_servers')
    add_ruby_socket_server_migration('create_friend_chats')
  end

  protected

  def add_ruby_socket_server_migration(template)
    migration_dir = File.expand_path('db/migrate')

    if !self.class.migration_exists?(migration_dir, template)
      migration_template "#{template}.rb", "db/migrate/#{template}.rb"
    end
  end
end
