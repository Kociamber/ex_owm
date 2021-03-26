use Mix.Config
config :logger, level: :info
config :ex_owm, api_key: System.get_env("OWM_API_KEY")

config :ex_owm, ExOwm.WeatherCache,
  gc_interval: :timer.hours(1),
  max_size: 1_000,
  # 20MB
  allocated_memory: 20_000_000,
  gc_cleanup_min_timeout: :timer.seconds(10),
  gc_cleanup_max_timeout: :timer.minutes(10),
  backend: :shards,
  stats: true
