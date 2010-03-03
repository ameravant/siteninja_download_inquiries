class AddTypeToInquiries < ActiveRecord::Migration
  def self.up
    add_column :inquiries, :type, :string
  end

  def self.down
    remove_column :inquiries, :type
  end
end
