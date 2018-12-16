use Mix.Config
config :logger, level: :info
config :ex_owm, api_key: System.get_env("OWM_API_KEY")

config :ex_owm, ExOwm.CurrentWeather.Cache,
  adapter: Nebulex.Adapters.Local,
  n_shards: 2,
  gc_interval: 3600

config :ex_owm, ExOwm.FiveDayForecast.Cache,
  adapter: Nebulex.Adapters.Local,
  n_shards: 2,
  gc_interval: 3600

config :ex_owm, ExOwm.SixteenDayForecast.Cache,
  adapter: Nebulex.Adapters.Local,
  n_shards: 2,
  gc_interval: 3600
