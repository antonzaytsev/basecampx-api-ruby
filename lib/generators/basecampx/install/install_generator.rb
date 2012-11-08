require 'rails/generators'

module Basecampx
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Copy Basecamp config file"
      #argument :name, :type => :string, :default => "AdminUser"
      #argument :password, :type => :string, :default => "AdminUser"

      #hook_for :users, :default => "devise", :desc => "Admin user generator to run. Skip with --skip-users"

      def self.source_root
        @source_root ||= File.join(File.dirname(__FILE__), 'templates')
      end

      def copy_initializer
        #@underscored_user_name = name.underscore
        #template 'active_admin.rb.erb', 'config/initializers/active_admin.rb'
      end

      def setup_directory
        template 'basecampx.yaml', 'config/basecampx.yaml'
      end

    end
  end
end