# # Puma can serve each request in a thread from an internal thread pool.
# # The `threads` method setting takes two numbers: a minimum and maximum.
# # Any libraries that use thread pools should be configured to match
# # the maximum value specified for Puma. Default is set to 5 threads for minimum
# # and maximum; this matches the default thread size of Active Record.
# #
# threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
# threads threads_count, threads_count

# # Specifies the `port` that Puma will listen on to receive requests; default is 3000.
# #
# port        ENV.fetch("PORT") { 3000 }

# # Specifies the `environment` that Puma will run in.
# #
# environment ENV.fetch("RAILS_ENV") { "development" }

# # Specifies the `pidfile` that Puma will use.
# pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }

# # Specifies the number of `workers` to boot in clustered mode.
# # Workers are forked webserver processes. If using threads and workers together
# # the concurrency of the application would be max `threads` * `workers`.
# # Workers do not work on JRuby or Windows (both of which do not support
# # processes).
# #
# # workers ENV.fetch("WEB_CONCURRENCY") { 2 }

# # Use the `preload_app!` method when specifying a `workers` number.
# # This directive tells Puma to first boot the application and load code
# # before forking the application. This takes advantage of Copy On Write
# # process behavior so workers use less memory.
# #
# # preload_app!

# # Allow puma to be restarted by `rails restart` command.
# plugin :tmp_restart

# # 追記
# bind "unix://#{Rails.root}/tmp/sockets/puma.sock"
# rails_root = Dir.pwd
# # 本番環境のみデーモン起動
# if Rails.env.production?
#   pidfile File.join(rails_root, 'tmp', 'pids', 'puma.pid')
#   state_path File.join(rails_root, 'tmp', 'pids', 'puma.state')
#   stdout_redirect(
#     File.join(rails_root, 'log', 'puma.log'),
#     File.join(rails_root, 'log', 'puma-error.log'),
#     true
#   )
#   # デーモン
#   daemonize
# end

# ===================-20220507書き換え(zenn AWSのEC2でデプロイするため）======================
max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

#port        ENV.fetch("PORT") { 3000 }
bind "unix:///var/www/Nomi-Joy/tmp/sockets/puma.sock"

environment ENV.fetch("RAILS_ENV") { "development" }

pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }

plugin :tmp_restart