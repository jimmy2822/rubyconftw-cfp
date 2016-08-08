# config valid only for current version of Capistrano
lock '3.5.0'

set :application, 'spottly-web'
set :repo_url, 'git@git.5xruby.tw:cfp/cfp.system.git'

# Default branch is :master
#
if ENV['USE_CURRENT_BRANCH'].to_i > 0
  set :branch, `git rev-parse --abbrev-ref HEAD`.chomp
elsif ENV.has_key?('USE_BRANCH')
  set :branch, ENV['USE_BRANCH']
else
  ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
end

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :debug

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml config/application.yml config/sidekiq.yml}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/uploads}


# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
set :default_env, { path: "$PATH:/usr/local/ruby23/bin:" }

# Default value for keep_releases is 5
set :keep_releases, 3

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      within release_path do
        execute :rake, 'tmp:clear'
      end
    end
  end

end
after :'deploy:publishing', :'deploy:restart'