# frozen_string_literal: true
redis_opts = {url: ENV.fetch('REDIS_URL')}

Sidekiq.configure_server do |config|
  config.redis = redis_opts
end

Sidekiq.configure_client do |config|
  config.redis = redis_opts
end

if Rails.env.production?
  local_logger = Logger.new(STDOUT)
  local_logger.formatter = Sidekiq::Logging::Pretty.new
  remote_logger = RemoteSyslogLogger.new(
    ENV['PAPERTRAIL_HOST'],
    ENV['PAPERTRAIL_PORT'].to_i,
    program: 'lunchiatto/sidekiq',
    local_hostname: 'lunchiatto-sidekiq',
  )
  remote_logger.formatter = Sidekiq::Logging::Pretty.new
  Sidekiq::Logging.logger = MultiLogger.new([local_logger, remote_logger])
  Sidekiq::Logging.logger.level = Logger::INFO
end
