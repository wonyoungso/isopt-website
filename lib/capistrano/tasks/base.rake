def template(from, to)
  erb = File.read(File.expand_path("../templates/#{from}", __FILE__))
  io   = StringIO.new(ERB.new(erb).result(binding))
  upload! io, to
end

def set_default(name, *args, &block)
  set(name, *args, &block)
end

namespace :deploy do
  desc "Install everything onto the server"
  task :install do
  end

  desc "Upgrade installed packages"
  task :upgrade do
    on roles(:web) do 
      execute "sudo apt-get -y update"
      execute "sudo apt-get -y upgrade"
    end
  end
end

namespace :base do
  desc "Install base package onto the server"
  task :install do
    on roles(:web) do 
      execute "sudo apt-get -y install python-software-properties"
      execute "sudo apt-get -y install gcc"
      execute "sudo apt-get -y update"

      execute "sudo apt-get -y install libxml2-dev libxslt1-dev" # Nokogiri
      execute "sudo apt-get -y install imagemagick" # CarrierWave
      # Manual bootstrap
      execute "sudo apt-get -y install build-essential zlib1g-dev libssl-dev libreadline-gplv2-dev"
    end
  end
end
