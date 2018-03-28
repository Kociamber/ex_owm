# ExOwm

[![Build Status](https://travis-ci.org/Kociamber/ex_owm.svg?branch=master)](https://travis-ci.org/Kociamber/ex_owm)
[![Hex version badge](https://img.shields.io/hexpm/v/ex_owm.svg)](https://hex.pm/packages/ex_owm)

**Fast, industrial strength [Open Weather Map](http://openweathermap.org/technology) interface for based Elixir platforms.**

## Installation

Add ExOwm as a dependency to your `mix.exs` file:

```elixir
defp deps() do
  [{:ex_owm, "~> 1.0"}]
end
```

## Configuration

In order to be able to use OWM APIs, you need to [register](https://home.openweathermap.org/users/sign_up) free account and get free API KEY.
After obtaining the key, please set environmental variable called OWM_API_KEY and set the value to your API KEY.

If you are going to use this application as a dependency in your own project, you will need to copy and paste below configuration to your `config/config.exs` file:

```elixir
config :ex_owm, api_key: System.get_env("OWM_API_KEY")

config :ex_owm, ExOwm.Cache.CurrentWeather,
  adapter: Nebulex.Adapters.Local,
  n_shards: 2,
  gc_interval: 3600

config :ex_owm, ExOwm.Cache.FiveDayForecast,
  adapter: Nebulex.Adapters.Local,
  n_shards: 2,
  gc_interval: 3600

config :ex_owm, ExOwm.Cache.SixteenDayForecast,
  adapter: Nebulex.Adapters.Local,
  n_shards: 2,
  gc_interval: 3600
```

..and you are ready to go!

## Basic Usage

ExOwm is currently handling three main OpenWeatherMap [APIs](http://openweathermap.org/api):

*   [Current weather data](http://openweathermap.org/current)
*   [5 day / 3 hour forecast](http://openweathermap.org/forecast5)
*   [1 - 16 day / daily forecast](http://openweathermap.org/forecast16)

Please note that with standard (free) license / API key you may be limited with amount of requests per minute and may not be able to access 1 - 16 day / daily forecast. Please refer to OpenWeatherMap license [plans](http://openweathermap.org/price).

There are three main public interface functions for each API and they accepts the same set of two params - a list of location maps and a keyword list of options.

Sample API calls may look following:
```elixir
ExOwm.get_current_weather([%{city: "Warsaw"}, %{city: "London", country_code: "uk"}], units: :metric, lang: :pl)
{:ok, %{WEATHER_DATA}}

ExOwm.get_five_day_forecast([%{city: "Warsaw"}, %{city: "London", country_code: "uk"}], units: :metric, lang: :pl)
{:ok, %{WEATHER_DATA}}

ExOwm.get_sixteen_day_forecast([%{city: "Warsaw"}, %{city: "London", country_code: "uk"}], units: :metric, lang: :pl, cnt: 16)
{:ok, %{WEATHER_DATA}}
```

Please refer to official [docs](https://hexdocs.pm/ex_owm/readme.html) for more details.

## Overivew

ExOwm is using cool features like:

*   concurrent API calls
*   super fast generational caching
*   access to **main** [OWM APIs](http://openweathermap.org/api)!

It means that each location entry passed within the list spawns separate task (Elixir worker process) which is checking wether the request has been already sent within a time interval, if yes, it's fetching the result from cache. Otherwise it sends API query, saves the result in cache and returns the data. 

## To be done in next release

*   Add cache TTL as a param for each interface
*   Add Historical Data API

## License

This project is MIT licensed. Please see the [`LICENSE.md`](https://github.com/Kociamber/ex_owm/blob/master/LICENSE.md) file for more details.
