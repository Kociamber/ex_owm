import Config
config :logger, level: :info
config :ex_owm, api_key: System.get_env("OWM_API_KEY")

# Default TTL for all endpoints (10 minutes)
config :ex_owm, :default_ttl, :timer.minutes(10)

# Per-endpoint TTL overrides (optional)
# config :ex_owm, :current_weather_ttl, :timer.minutes(10)
# config :ex_owm, :one_call_ttl, :timer.minutes(10)
# config :ex_owm, :forecast_5day_ttl, :timer.hours(1)
# config :ex_owm, :forecast_hourly_ttl, :timer.hours(1)
# config :ex_owm, :forecast_16day_ttl, :timer.hours(6)
# config :ex_owm, :historical_ttl, :timer.hours(24)

config :ex_owm, ExOwm.Cache,
  gc_interval: :timer.hours(1),
  max_size: 1_000,
  # 20MB
  allocated_memory: 20_000_000,
  gc_cleanup_min_timeout: :timer.seconds(10),
  gc_cleanup_max_timeout: :timer.minutes(10),
  backend: :shards,
  stats: true
