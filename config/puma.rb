workers Integer(ENV['WEB_CONCURRENCY'] || 3)
max_threads_count = Integer(ENV['MAX_THREADS'] || 1)
min_threads_count = Integer(ENV['MIN_THREADS'] || 1)
threads min_threads_count, max_threads_count

preload_app!

port ENV['PORT'] || 3000
environment ENV['RACK_ENV'] || 'development'

on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end

before_fork do
  ActiveRecord::Base.connection_pool.disconnect!
end

# DUPA
