# ExOwm

[![Build Status](https://travis-ci.org/Kociamber/ex_owm.svg?branch=master)](https://travis-ci.org/Kociamber/ex_owm)
[![Hex version badge](https://img.shields.io/hexpm/v/ex_owm.svg)](https://hex.pm/packages/ex_owm)

**Fast [Open Weather Map](http://openweathermap.org/technology) API client for Elixir applications.**

## Installation

Add ExOwm as a dependency to your `mix.exs` file:

```elixir
defp deps() do
  [{:ex_owm, "~> 1.3.0"}]
end
```

## Upgrade from 1.0.X

**Please re-factor** your configuration as the module naming (specifically the order) has slightly changed. Use the configuration below:

## Configuration

To use OWM APIs, you need to [register](https://home.openweathermap.org/users/sign_up) for an account (free plan is available) and obtain an API key. After obtaining the key, set the environment variable OWM_API_KEY to your API key.

If you are using this application as a dependency in your project, add the following configuration to your `config/config.exs` file:

```elixir
config :ex_owm, api_key: System.get_env("OWM_API_KEY")
```

..and you are ready to go!

## Basic Usage

ExOwm currently handles the following main OpenWeatherMap [APIs](http://openweathermap.org/api):

*   [Current weather data](http://openweathermap.org/current)
*   [One Call API](https://openweathermap.org/api/one-call-api)
*   [One Call API History](https://openweathermap.org/api/one-call-api#history)
*   [5 day / 3 hour forecast](http://openweathermap.org/forecast5)
*   [1 - 16 day / daily forecast](http://openweathermap.org/forecast16)

Please note that with a standard (free) license/API key, you may be limited in the number of requests per minute and may not have access to the 1 - 16 day/daily forecast. Please refer to OpenWeatherMap [pricing plans](http://openweathermap.org/price) for more details..

There are three main public interface functions for each API, accepting the same set of two parameters: a list of location maps and a keyword list of options.

Sample API calls:

```elixir
ExOwm.get_current_weather([%{city: "Warsaw"}, %{city: "London", country_code: "uk"}], units: :metric, lang: :pl)
[{:ok, %{WARSAW_DATA}}, {:ok, %{LONDON_DATA}}]

ExOwm.get_five_day_forecast([%{city: "Warsaw"}, %{city: "London", country_code: "uk"}], units: :metric, lang: :pl)
[{:ok, %{WARSAW_DATA}}, {:ok, %{LONDON_DATA}}]

ExOwm.get_sixteen_day_forecast([%{city: "Warsaw"}, %{city: "unknown City Name", country_code: "uk"}], units: :metric, lang: :pl, cnt: 16)
[{:ok, %{WARSAW_DATA}}, {:error, :not_found, %{"cod" => "404", "message" => "city not found"}}]

yesterday = DateTime.utc_now() |> DateTime.add(24 * 60 * 60 * -1, :second) |> DateTime.to_unix()
ExOwm.get_historical_weather([%{lat: 52.374031, lon: 4.88969, dt: yesterday}])
[{:ok, %{CITY_DATA}}]

```

For more details, refer to the official [docs](https://hexdocs.pm/ex_owm/readme.html).

## Overview

ExOwm utilizes some cool features such as:

*   concurrent API calls
*   super fast generational caching
*   access to **main** [OWM APIs](http://openweathermap.org/api)!

Each location entry in the list spawns a separate task (Elixir worker process) to check whether the request has been made within a specified time interval. If it has, the result is fetched from the cache. Otherwise, an API query is sent, the result is cached, and the data is returned.

## Running local tests

Since all the tests are based on OWM API calls, they are disabled by default. To enable them, please remove `:api_based_test` from the `test/test_helper.exs file`.

## To do

*   Add remaining OWM APIs (including One Call API 3.0)

## License

This project is MIT licensed. Please see the [`LICENSE.md`](https://github.com/Kociamber/ex_owm/blob/master/LICENSE.md) file for more details.
