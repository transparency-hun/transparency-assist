# frozen_string_literal: true
server '46.101.248.169', user: fetch(:user), roles: %w(web app db)
server '35.157.111.167', user: fetch(:user), roles: %w(app)

set :branch, 'master'

set :log_level, :info

set :rails_env, 'production'
set :puma_env, 'production'

set :puma_bind,       "unix://#{shared_path}/tmp/sockets/puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"

set :nginx_application_name, 'transparency_assist_production'
set :nginx_domains, 'assist.transparency.hu'
set :nginx_use_ssl, false
