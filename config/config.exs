
use Mix.Config
config :logger, level: :info

import_config "#{Mix.env}.secret.exs"
