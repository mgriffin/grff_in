# config valid for current version and patch releases of Capistrano
lock "~> 3.17.3"

set :application, "grff_in"
set :repo_url, "git@github.com:mgriffin/grff_in.git"

set :branch, :main

append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', '.bundle', 'public/system', 'public/uploads'
append :linked_files, 'config/database.yml', "config/master.key"

set :migration_role, :app

set :rbenv_type, :user
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w[rake gem bundle ruby rails]
set :rbenv_roles, :production

set :puma_enable_socket_service, true
set :puma_service_unit_name, "puma_grff_in_production"
set :puma_systemctl_user, :system

namespace :deploy do
  namespace :check do
    before :linked_files, :set_master_key do
      on roles(:app) do
        unless test("[ -f #{shared_path}/config/master.key ]")
          upload! 'config/master.key', "#{shared_path}/config/master.key"
        end
      end
    end
    before :linked_files, :set_database_yml do
      on roles(:app) do
        upload! 'config/database.yml', "#{shared_path}/config/database.yml"
      end
    end
  end
end
