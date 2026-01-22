defmodule ExOwm.Location do
  @moduledoc """
  Validated location types for OpenWeatherMap API requests.

  This module provides constructors for creating validated location structs
  that can be used with ExOwm API functions.

  ## Examples

      iex> ExOwm.Location.by_city("Warsaw")
      %ExOwm.Location{type: :city, city: "Warsaw", country: nil}

      iex> ExOwm.Location.by_coords(52.374031, 4.88969)
      %ExOwm.Location{type: :coords, lat: 52.374031, lon: 4.88969}

      iex> ExOwm.Location.by_id(2759794)
      %ExOwm.Location{type: :id, id: 2759794}

      iex> ExOwm.Location.by_zip("94040", country: "us")
      %ExOwm.Location{type: :zip, zip: "94040", country: "us"}

  """

  defstruct [:type, :city, :country, :lat, :lon, :id, :zip, :dt, :query]

  @type t :: %__MODULE__{
          type: :city | :coords | :id | :zip | :geocode_query,
          city: String.t() | nil,
          country: String.t() | nil,
          lat: float() | nil,
          lon: float() | nil,
          id: pos_integer() | nil,
          zip: String.t() | nil,
          dt: pos_integer() | nil,
          query: String.t() | nil
        }

  @doc """
  Creates a location by city name.

  ## Options

    * `:country` - ISO 3166 country code (e.g., "us", "pl", "uk")

  ## Examples

      iex> ExOwm.Location.by_city("Warsaw")
      %ExOwm.Location{type: :city, city: "Warsaw", country: nil}

      iex> ExOwm.Location.by_city("London", country: "uk")
      %ExOwm.Location{type: :city, city: "London", country: "uk"}

  """
  @spec by_city(String.t(), keyword()) :: t()
  def by_city(city, opts \\ []) when is_binary(city) and is_list(opts) do
    country = Keyword.get(opts, :country)
    validate_country!(country)

    %__MODULE__{
      type: :city,
      city: city,
      country: country
    }
  end

  @doc """
  Creates a location by geographic coordinates.

  ## Parameters

    * `lat` - Latitude (-90 to 90)
    * `lon` - Longitude (-180 to 180)

  ## Examples

      iex> ExOwm.Location.by_coords(52.374031, 4.88969)
      %ExOwm.Location{type: :coords, lat: 52.374031, lon: 4.88969}

  """
  @spec by_coords(float(), float()) :: t()
  def by_coords(lat, lon) when is_number(lat) and is_number(lon) do
    validate_latitude!(lat)
    validate_longitude!(lon)

    %__MODULE__{
      type: :coords,
      lat: lat * 1.0,
      lon: lon * 1.0
    }
  end

  @doc """
  Creates a location by OpenWeatherMap city ID.

  ## Examples

      iex> ExOwm.Location.by_id(2759794)
      %ExOwm.Location{type: :id, id: 2759794}

  """
  @spec by_id(pos_integer()) :: t()
  def by_id(id) when is_integer(id) and id > 0 do
    %__MODULE__{
      type: :id,
      id: id
    }
  end

  @doc """
  Creates a location by ZIP/postal code.

  ## Options

    * `:country` - ISO 3166 country code (required)

  ## Examples

      iex> ExOwm.Location.by_zip("94040", country: "us")
      %ExOwm.Location{type: :zip, zip: "94040", country: "us"}

  """
  @spec by_zip(String.t(), keyword()) :: t()
  def by_zip(zip, opts) when is_binary(zip) and is_list(opts) do
    country = Keyword.fetch!(opts, :country)
    validate_country!(country)

    %__MODULE__{
      type: :zip,
      zip: zip,
      country: country
    }
  end

  @doc """
  Adds a timestamp to a location (for historical weather queries).

  ## Parameters

    * `location` - An existing location struct
    * `timestamp` - Unix timestamp

  ## Examples

      iex> location = ExOwm.Location.by_coords(52.374031, 4.88969)
      iex> ExOwm.Location.with_timestamp(location, 1615546800)
      %ExOwm.Location{type: :coords, lat: 52.374031, lon: 4.88969, dt: 1615546800}

  """
  @spec with_timestamp(t(), pos_integer()) :: t()
  def with_timestamp(%__MODULE__{} = location, timestamp)
      when is_integer(timestamp) and timestamp > 0 do
    %{location | dt: timestamp}
  end

  @doc false
  def from_map(%{city: city, country_code: country}), do: by_city(city, country: country)
  def from_map(%{city: city}), do: by_city(city)
  def from_map(%{id: id}), do: by_id(id)
  def from_map(%{lat: lat, lon: lon, dt: dt}), do: with_timestamp(by_coords(lat, lon), dt)
  def from_map(%{lat: lat, lon: lon}), do: by_coords(lat, lon)
  def from_map(%{zip: zip, country_code: country}), do: by_zip(zip, country: country)
  def from_map(map), do: raise(ArgumentError, invalid_location_message(map))

  defp validate_country!(country) when is_nil(country), do: :ok
  defp validate_country!(country) when is_binary(country), do: :ok

  defp validate_country!(country) do
    raise ArgumentError, "country must be a string, got: #{inspect(country)}"
  end

  defp validate_latitude!(lat) when lat >= -90 and lat <= 90, do: :ok

  defp validate_latitude!(lat) do
    raise ArgumentError, "latitude must be between -90 and 90, got: #{lat}"
  end

  defp validate_longitude!(lon) when lon >= -180 and lon <= 180, do: :ok

  defp validate_longitude!(lon) do
    raise ArgumentError, "longitude must be between -180 and 180, got: #{lon}"
  end

  defp invalid_location_message(map) do
    """
    Invalid location map: #{inspect(map)}

    Expected one of:
      %{city: "City"}
      %{city: "City", country_code: "cc"}
      %{id: 123}
      %{lat: 52.37, lon: 4.88}
      %{lat: 52.37, lon: 4.88, dt: 1615546800}
      %{zip: "12345", country_code: "us"}

    Or use ExOwm.Location constructors:
      ExOwm.Location.by_city("Warsaw")
      ExOwm.Location.by_coords(52.37, 4.88)
      ExOwm.Location.by_id(2759794)
      ExOwm.Location.by_zip("94040", country: "us")
    """
  end
end
