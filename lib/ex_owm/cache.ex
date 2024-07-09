defmodule ExOwm.Cache do
  @moduledoc false
  use Nebulex.Cache, otp_app: :ex_owm, adapter: Nebulex.Adapters.Local
end
