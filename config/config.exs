
use Mix.Config
config :logger, level: :info

config :ex_owm, ExOwm.Cache,
  adapter: Nebulex.Adapters.Local,
  n_shards: 2,
  gc_interval: 3600

import_config "#{Mix.env}.secret.exs"
