defmodule ExOwm.FiveDayForecast.Cache do
  use Nebulex.Cache, otp_app: :ex_owm, adapter: Nebulex.Adapters.Local
end
