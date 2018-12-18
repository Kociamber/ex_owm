defmodule ExOwm.CurrentWeather.Cache do
  use Nebulex.Cache, otp_app: :ex_owm, adapter: Nebulex.Adapters.Local
end
