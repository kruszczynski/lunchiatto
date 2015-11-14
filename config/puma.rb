workers Integer(ENV['WEB_CONCURRENCY'] || 3)
max_threads_count = Integer(ENV['MAX_THREADS'] || 1)
min_threads_count = Integer(ENV['MIN_THREADS'] || 1)
threads min_threads_count, max_threads_count

preload_app!

port ENV['PORT'] || 3000
environment ENV['RACK_ENV'] || 'development'

on_worker_boot do
  # Worker specific setup for Rails 4.1+
  # See: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#on-worker-boot
  ActiveRecord::Base.establish_connection
end

before_fork do
  ActiveRecord::Base.connection_pool.disconnect!
end
