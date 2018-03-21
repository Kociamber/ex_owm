use Mix.Config
config :logger, level: :info
config :ex_owm, api_key: System.get_env("OWM_API_KEY") 

config :ex_owm, ExOwm.Cache.CurrentWeather,
  adapter: Nebulex.Adapters.Local,
  n_shards: 2,
  gc_interval: 3600

config :ex_owm, ExOwm.Cache.FiveDayForecast,
  adapter: Nebulex.Adapters.Local,
  n_shards: 2,
  gc_interval: 3600

config :ex_owm, ExOwm.Cache.SixteenDayForecast,
  adapter: Nebulex.Adapters.Local,
  n_shards: 2,
  gc_interval: 3600
