# frozen_string_literal: true
if Rails.env.development? || Rails.env.test?
  require 'rspec/core/rake_task'
  require 'rubocop/rake_task'

  namespace :ci do
    desc 'Run specs'
    RSpec::Core::RakeTask.new(:specs) do |t|
      t.verbose = false
      t.rspec_opts = ['--require turnip/rspec',
                      "--pattern '**/*_spec.rb,**/*.feature'",
                      '--format documentation',
                      '-t ~@skip-ci',
                      '--failure-exit-code 1']
    end

    desc 'Run rubocop'
    RuboCop::RakeTask.new(:rubocop) do |t|
      t.fail_on_error = true
      t.verbose = false

      t.formatters = ['RuboCop::Formatter::SimpleTextFormatter']
      t.options = ['-D']
    end

    desc 'Deletes unneded files.'
    task :clean do
      dirs_to_clean = ["#{Rails.root}/spec/tmp/attachments/"]
      dirs_to_clean.each do |dirname|
        next unless File.directory?(dirname)
        FileUtils.remove_dir(dirname)
      end
    end

    desc 'Run things for ci'
    task build: :clean do
      puts "\033[34mRunning rubocop:\033[0m"
      Rake::Task['ci:rubocop'].invoke

      puts

      puts "\033[34mRunning rspec:\033[0m"

      ENV['COVERAGE'] = 'true'
      Rake::Task['ci:specs'].invoke
    end
  end
end
