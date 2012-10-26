class CreateServers < ActiveRecord::Migration
  def self.up
    create_table :servers do |t|
      t.string    :ip_addr, :null => false
      t.integer   :port, :null => false, :default => 80

      t.timestamps
    end
  end

  def self.down
    drop_table :servers
  end
end
