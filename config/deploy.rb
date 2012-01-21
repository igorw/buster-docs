require "bundler/capistrano"

$:.unshift(File.expand_path("./lib", ENV["rvm_path"]))
require "rvm/capistrano"
set :rvm_ruby_string, "1.9.3@passenger"

set :application, "buster-docs"
set :user, "buster"
set :use_sudo, false

set :scm, "git"
set :repository, "git@github.com:busterjs/buster-docs.git"

role :app, "109.74.202.156"
role :web, "109.74.202.156"
# role :db, "109.74.202.156", :primary => true

set :deploy_to, "/home/buster/sites/docs.busterjs.org"
set :deploy_via, :remote_cache
ssh_options[:keys] = %[/Users/#{user}/.ssh/id_rsa /home/#{user}/.ssh/id_rsa]
ssh_options[:forward_agent] = true

namespace :deploy do
  [:stop, :start, :restart].each do |cmd|
    desc "#{cmd.to_s.capitalize} Apache/mod_rails"
    task cmd, :roles => :app do
      run "touch #{release_path}/tmp/restart.txt"
    end
  end
end
