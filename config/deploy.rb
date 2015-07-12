# config valid only for current version of Capistrano
lock '3.4.0'


set :application, 'isopt.wonyoung.so'
set :domain, 'isopt.wonyoung.so'
server "isopt.wonyoung.so", user: "deployer", roles: %w{web app db}

set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.2.0'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"

set :deploy_to, "/home/deployer/isopt_website"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :web # default value

# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }
# 
set :linked_files, %w{config/database.yml pids/unicorn.pid}

set :user, "deployer"
set :deploy_user, "deployer"

set :scm, :git
set :repo_url, "git@github.com:wonyoungso/isopt-website.git"
set :keep_releases, 4
set :pty, true

set :use_sudo, false
set :copy_exclude, [".git", ".DS_Store", ".gitignore", ".gitsubmodule"]
set :deploy_to, "/home/#{fetch(:user)}/#{fetch(:application)}" 

set :netssh_options, {
  forward_agent: true,
  port: 3456
}

set :branch, ENV["REVISION"] || ENV["BRANCH_NAME"] || "stable"
set :stage, :production
set :linked_dirs, %w{tmp/pids log }


namespace :deploy do

  after :finishing, "unicorn:restart"

end