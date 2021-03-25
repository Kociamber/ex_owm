# ExOwm

[![Build Status](https://travis-ci.org/Kociamber/ex_owm.svg?branch=master)](https://travis-ci.org/Kociamber/ex_owm)
[![Hex version badge](https://img.shields.io/hexpm/v/ex_owm.svg)](https://hex.pm/packages/ex_owm)

**Fast, industrial strength [Open Weather Map](http://openweathermap.org/technology) interface for Elixir platforms.**

## Installation

Add ExOwm as a dependency to your `mix.exs` file:

```elixir
defp deps() do
  [{:ex_owm, "~> 1.1.1"}]
end
```

## Upgrade from 1.0.X

**Please re-factor** your configuration and paste below one once again as module naming (specifically the order) has slightly changed!

## Configuration

In order to be able to use OWM APIs, you need to [register](https://home.openweathermap.org/users/sign_up) free account and get free API KEY.
After obtaining the key, please set environmental variable called OWM_API_KEY and set the value to your API KEY.

If you are going to use this application as a dependency in your own project, you will need to copy and paste below configuration to your `config/config.exs` file:

```elixir
config :ex_owm, api_key: System.get_env("OWM_API_KEY")
```

..and you are ready to go!

## Basic Usage

ExOwm is currently handling the following main OpenWeatherMap [APIs](http://openweathermap.org/api):

*   [Current weather data](http://openweathermap.org/current)
*   [One Call API](https://openweathermap.org/api/one-call-api)
*   [One Call API History](https://openweathermap.org/api/one-call-api#history)
*   [5 day / 3 hour forecast](http://openweathermap.org/forecast5)
*   [1 - 16 day / daily forecast](http://openweathermap.org/forecast16)

Please note that with standard (free) license / API key you may be limited with amount of requests per minute and may not be able to access 1 - 16 day / daily forecast. Please refer to OpenWeatherMap license [plans](http://openweathermap.org/price).

There are three main public interface functions for each API and they accepts the same set of two params - a list of location maps and a keyword list of options.

Sample API calls may look following:
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

Please refer to official [docs](https://hexdocs.pm/ex_owm/readme.html) for more details.

## Overview

ExOwm is using cool features like:

*   concurrent API calls
*   super fast generational caching
*   access to **main** [OWM APIs](http://openweathermap.org/api)!

It means that each location entry passed within the list spawns separate task (Elixir worker process) which is checking whether the request has been already sent within a time interval, if yes, it's fetching the result from cache. Otherwise it sends API query, saves the result in cache and returns the data.

## To do

*   Add Historical Data API

## License

This project is MIT licensed. Please see the [`LICENSE.md`](https://github.com/Kociamber/ex_owm/blob/master/LICENSE.md) file for more details.
