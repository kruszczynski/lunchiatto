redis_opts = {url: 'redis://redis:6379'}

Sidekiq.configure_server do |config|
  config.redis = redis_opts
end

Sidekiq.configure_client do |config|
  config.redis = redis_opts
end
