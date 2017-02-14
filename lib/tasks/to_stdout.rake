# frozen_string_literal: true
desc 'Switch logger to stdout'
task to_stdout: [:environment] do
  logger = Logger.new(STDOUT)
  logger.level = Logger::DEBUG
  Rails.logger = logger
end
