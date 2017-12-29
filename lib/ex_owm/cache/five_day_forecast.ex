defmodule ExOwm.Cache.FiveDayForecast do
  use Nebulex.Cache, otp_app: :ex_owm, adapter: Nebulex.Adapters.Local
end
