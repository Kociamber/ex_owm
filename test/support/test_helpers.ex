defmodule ExOwm.TestHelpers do
  @moduledoc """
  Shared test utilities and helpers.
  """

  @doc """
  Sets up a Bypass server for testing HTTP requests.
  """
  def setup_bypass(_context) do
    bypass = Bypass.open()
    {:ok, bypass: bypass}
  end

  @doc """
  Builds a full URL for a Bypass server.
  """
  def bypass_url(bypass, path \\ "/") do
    "http://localhost:#{bypass.port}#{path}"
  end

  @doc """
  Configures Bypass to return a successful response with flexible content handling.
  """
  def expect_success(bypass, path, response_body, content_type \\ "application/json") do
    Bypass.expect(bypass, "GET", path, fn conn ->
      conn
      |> Plug.Conn.put_resp_content_type(content_type)
      |> Plug.Conn.resp(200, response_body)
    end)
  end

  @doc """
  Configures Bypass to return an error response with flexible content handling.
  """
  def expect_error(bypass, path, status, response_body) do
    Bypass.expect(bypass, "GET", path, fn conn ->
      conn
      |> Plug.Conn.put_resp_content_type("application/json")
      |> Plug.Conn.resp(status, response_body)
    end)
  end

  @doc """
  Captures telemetry events for testing.
  """
  def capture_telemetry_events(event_prefix, fun) do
    test_pid = self()
    ref = make_ref()

    handler_id = {__MODULE__, ref, event_prefix}

    :telemetry.attach_many(
      handler_id,
      [event_prefix ++ [:start], event_prefix ++ [:stop]],
      fn event_name, measurements, metadata, _config ->
        send(test_pid, {:telemetry_event, ref, event_name, measurements, metadata})
      end,
      nil
    )

    result = fun.()

    :telemetry.detach(handler_id)

    events =
      receive_all_telemetry_events(ref)
      |> Enum.map(fn {_ref, event_name, measurements, metadata} ->
        {event_name, measurements, metadata}
      end)

    {result, events}
  end

  defp receive_all_telemetry_events(ref, acc \\ []) do
    receive do
      {:telemetry_event, ^ref, event_name, measurements, metadata} ->
        receive_all_telemetry_events(ref, [{ref, event_name, measurements, metadata} | acc])
    after
      100 -> Enum.reverse(acc)
    end
  end
end
