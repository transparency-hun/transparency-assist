# frozen_string_literal: true
# config valid only for current version of Capistrano
lock '3.6.0'

set :application,  'transparency_assist'
set :user,         'deployer'
set :repo_url,     'git@github.com:transparency-hun/transparency-assist.git'
set :deploy_to,     "/home/#{fetch(:user)}/apps/#{fetch(:application)}/#{fetch(:stage)}"
set :keep_releases, 5

set :rvm_ruby_version, '2.3.1@transparency-assist'

set :puma_worker_timeout, 60
set :puma_init_active_record, true
set :puma_preload_app, true

set :linked_files, fetch(:linked_files, []).push('.env', ".env.#{fetch(:stage)}", 'config/database.yml')

set :linked_dirs, fetch(:linked_dirs, []).push('log',
                                               'tmp/pids',
                                               'tmp/cache',
                                               'tmp/sockets',
                                               'vendor/bundle',
                                               'public/static',
                                               'public/system')
