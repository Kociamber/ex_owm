defmodule ExOwm.Cache.SixteenDayForecast do
  use Nebulex.Cache, otp_app: :ex_owm, adapter: Nebulex.Adapters.Local
end
