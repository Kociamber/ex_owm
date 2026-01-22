defmodule ExOwm.Fixtures do
  @moduledoc """
  Test fixtures with sample API responses from OpenWeatherMap.
  """

  def current_weather_response do
    %{
      "coord" => %{"lon" => 21.0118, "lat" => 52.2298},
      "weather" => [
        %{
          "id" => 800,
          "main" => "Clear",
          "description" => "clear sky",
          "icon" => "01d"
        }
      ],
      "base" => "stations",
      "main" => %{
        "temp" => 283.15,
        "feels_like" => 281.12,
        "temp_min" => 282.04,
        "temp_max" => 284.26,
        "pressure" => 1013,
        "humidity" => 65
      },
      "visibility" => 10000,
      "wind" => %{
        "speed" => 3.6,
        "deg" => 220
      },
      "clouds" => %{"all" => 0},
      "dt" => 1_643_723_400,
      "sys" => %{
        "type" => 2,
        "id" => 2_032_856,
        "country" => "PL",
        "sunrise" => 1_643_695_896,
        "sunset" => 1_643_729_054
      },
      "timezone" => 3600,
      "id" => 756_135,
      "name" => "Warsaw",
      "cod" => 200
    }
  end

  def one_call_response do
    %{
      "lat" => 52.37,
      "lon" => 4.89,
      "timezone" => "Europe/Amsterdam",
      "timezone_offset" => 3600,
      "current" => %{
        "dt" => 1_643_723_400,
        "sunrise" => 1_643_695_200,
        "sunset" => 1_643_727_800,
        "temp" => 275.32,
        "feels_like" => 272.18,
        "pressure" => 1022,
        "humidity" => 81,
        "dew_point" => 272.33,
        "uvi" => 0.5,
        "clouds" => 20,
        "visibility" => 10000,
        "wind_speed" => 4.12,
        "wind_deg" => 240,
        "weather" => [
          %{
            "id" => 801,
            "main" => "Clouds",
            "description" => "few clouds",
            "icon" => "02d"
          }
        ]
      },
      "hourly" => [
        %{
          "dt" => 1_643_720_400,
          "temp" => 275.15,
          "feels_like" => 271.98,
          "pressure" => 1022,
          "humidity" => 82,
          "weather" => [%{"id" => 801}]
        }
      ],
      "daily" => [
        %{
          "dt" => 1_643_713_200,
          "temp" => %{
            "day" => 275.32,
            "min" => 273.15,
            "max" => 277.15,
            "night" => 274.15,
            "eve" => 275.82,
            "morn" => 274.32
          },
          "weather" => [%{"id" => 800}]
        }
      ]
    }
  end

  def forecast_5day_response do
    %{
      "cod" => "200",
      "message" => 0,
      "cnt" => 40,
      "list" => [
        %{
          "dt" => 1_643_724_000,
          "main" => %{
            "temp" => 283.15,
            "feels_like" => 281.12,
            "temp_min" => 282.04,
            "temp_max" => 284.26,
            "pressure" => 1013,
            "humidity" => 65
          },
          "weather" => [
            %{"id" => 800, "main" => "Clear", "description" => "clear sky"}
          ],
          "clouds" => %{"all" => 0},
          "wind" => %{"speed" => 3.6, "deg" => 220},
          "visibility" => 10000,
          "pop" => 0,
          "dt_txt" => "2022-02-01 12:00:00"
        }
      ],
      "city" => %{
        "id" => 756_135,
        "name" => "Warsaw",
        "coord" => %{"lat" => 52.2298, "lon" => 21.0118},
        "country" => "PL",
        "population" => 1_702_139,
        "timezone" => 3600,
        "sunrise" => 1_643_695_896,
        "sunset" => 1_643_729_054
      }
    }
  end

  def error_not_found do
    %{
      "cod" => "404",
      "message" => "city not found"
    }
  end

  def error_invalid_api_key do
    %{
      "cod" => 401,
      "message" =>
        "Invalid API key. Please see https://openweathermap.org/faq#error401 for more info."
    }
  end

  def error_bad_request do
    %{
      "cod" => "400",
      "message" => "wrong latitude"
    }
  end
end
