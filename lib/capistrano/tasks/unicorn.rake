set :application, "thethings.kr"
set :user, "deployer"

set :unicorn_user, "deployer"
set :unicorn_pid, "/home/#{fetch(:user)}/#{fetch(:application)}/shared/pids/unicorn.pid"
set :unicorn_config, "/home/#{fetch(:user)}/#{fetch(:application)}/shared/config/unicorn.rb"
set :unicorn_log, "/home/#{fetch(:user)}/#{fetch(:application)}/shared/log/unicorn.log"
set :unicorn_workers, 4



namespace :unicorn do
  desc "Setup Unicorn initializer and app configuration"
  task :setup do
    on roles(:web) do 
      execute "mkdir -p /home/#{fetch(:user)}/#{fetch(:application)}/shared/config"
      template "unicorn.rb.erb", fetch(:unicorn_config)
      template "unicorn_init.erb", "/tmp/unicorn_init"
      execute :sudo, "chmod +x /tmp/unicorn_init"
      execute :sudo, "mv /tmp/unicorn_init /etc/init.d/unicorn_#{fetch(:application)}"
      execute :sudo, "update-rc.d -f unicorn_#{fetch(:application)} defaults"
    end
  end

  desc "restart unicorn"
  task :restart do
    on roles(:web) do 
      execute "service unicorn_#{fetch(:application)} restart"
    end
  end
end