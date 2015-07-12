set :branch, ENV["REVISION"] || ENV["BRANCH_NAME"] || "stable"
set :stage, :production

set :application, 'isopt.wonyoung.so'
set :domain, 'isopt.wonyoung.so'
server "isopt.wonyoung.so", user: "deployer", roles: %w{web app db}

# set :ssh_options, {
#     user: 'deployer',
#     keys: %w(/home/WonyoungSo/.ssh/id_rsa),
#     forward_agent: false
# }
