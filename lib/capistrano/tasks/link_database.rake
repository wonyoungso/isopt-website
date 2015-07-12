
namespace :db_s3_yml do
  desc "Setup Database and s3 file to shared directory"
  task :setup do
    on roles(:web) do 
      execute "mkdir -p /home/#{fetch(:user)}/#{fetch(:application)}/shared/config"
      upload! "/Users/WonyoungSo/Desktop/isopt_website/config/database.yml", "/home/#{fetch(:user)}/#{fetch(:application)}/shared/config/database.yml"
      # template "unicorn_init.erb", "/tmp/unicorn_init"
      # execute "chmod +x /tmp/unicorn_init"
      # execute "mv /tmp/unicorn_init /etc/init.d/unicorn_#{fetch(:application)}"
      # execute "update-rc.d -f unicorn_#{fetch(:application)} defaults"
    end
  end
end