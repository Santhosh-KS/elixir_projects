defmodule HelloTesla do
  @moduledoc """
  Documentation for `HelloTesla`.
  """

  @doc """
  Hello world.

  ## Examples

      iex(29)> rs = HelloTesla.run("rs")
      [
        %{
          "region" => "Europe",
          "idd" => %{"root" => "+3", "suffixes" => ["81"]},
          "car" => %{"side" => "right", "signs" => ["SRB"]},
          "cca3" => "SRB",
          "demonyms" => %{
            "eng" => %{"f" => "Serbian", "m" => "Serbian"},
            "fra" => %{"f" => "Serbe", "m" => "Serbe"}
          },
          "cioc" => "SRB",
          "tld" => [".rs", ".срб"],
          "cca2" => "RS",
          "gini" => %{"2017" => 36.2},
          "maps" => %{
            "googleMaps" => "https://goo.gl/maps/2Aqof7aV2Naq8YEK8",
            "openStreetMaps" => "https://www.openstreetmap.org/relation/1741311"
          },
          "startOfWeek" => "monday",
          "area" => 88361.0,
          "continents" => ["Europe"],
          "timezones" => ["UTC+01:00"],
          "flags" => %{
            "alt" => "The flag of Serbia is composed of three equal horizontal bands of red, blue and white. The coat of arms of Serbia is superimposed at the center of the field slightly towards the hoist side.",
            "png" => "https://flagcdn.com/w320/rs.png",
            "svg" => "https://flagcdn.com/rs.svg"
          },
          "status" => "officially-assigned",
          "independent" => true,
          "name" => %{
            "common" => "Serbia",
            "nativeName" => %{
              "srp" => %{
                "common" => "Србија",
                "official" => "Република Србија"
              }
            },
            "official" => "Republic of Serbia"
          },
          "fifa" => "SRB",
          "population" => 6908224,
          "subregion" => "Southeast Europe",
          "coatOfArms" => %{
            "png" => "https://mainfacts.com/media/images/coats_of_arms/rs.png",
            "svg" => "https://mainfacts.com/media/images/coats_of_arms/rs.svg"
          },
          "altSpellings" => ["RS", "Srbija", "Republic of Serbia",
           "Република Србија", "Republika Srbija"],
          "capitalInfo" => %{"latlng" => [44.83, 20.5]},
          "unMember" => true,
          "capital" => ["Belgrade"],
          "languages" => %{"srp" => "Serbian"},
          "landlocked" => true,
          "flag" => "🇷🇸",
          "postalCode" => %{"format" => "######", "regex" => "^(\\d{6})$"},
          "latlng" => [44.0, 21.0],
          "borders" => ["BIH", "BGR", "HRV", "HUN", "UNK", "MKD", "MNE", "ROU"],
          "currencies" => %{
            "RSD" => %{"name" => "Serbian dinar", "symbol" => "дин."}
          },
          "translations" => %{
            "ara" => %{
              "common" => "صيربيا",
              "official" => "جمهورية صيربيا"
            },
            "bre" => %{"common" => "Serbia", "official" => "Republik Serbia"},
            "ces" => %{"common" => "Srbsko", "official" => "Srbská republika"},
            "cym" => %{"common" => "Serbia", "official" => "Republic of Serbia"},
            "deu" => %{"common" => "Serbien", "official" => "Republik Serbien"},
            "est" => %{"common" => "Serbia", "official" => "Serbia Vabariik"},
            "fin" => %{"common" => "Serbia", "official" => "Serbian tasavalta"},
            "fra" => %{"common" => "Serbie", "official" => "République de Serbie"},
            "hrv" => %{"common" => "Srbija", "official" => "Republika Srbija"},
            "hun" => %{"common" => "Szerbia", "official" => "Szerb Köztársaság"},
            "ind" => %{"common" => "Serbia", "official" => "Republik Serbia"},
            "ita" => %{"common" => "Serbia", "official" => "Repubblica di Serbia"},
            "jpn" => %{
              "common" => "セルビア",
              "official" => "セルビア共和国"
            },
            "kor" => %{"common" => "세르비아", ...},
            "nld" => %{...},
            ...
          },
          "ccn3" => "688"
        }
      ]
      iex(30)> List.first(r)["postalCode"]
      %{"format" => nil, "regex" => nil}
      iex(31)> List.first(rs)["postalCode"]
      %{"format" => "######", "regex" => "^(\\d{6})$"}
      iex(32)> List.first(rs)["startOfTheWeek"]
      nil
      iex(33)> List.first(rs)["startOfWeek"]
      "monday"
      iex(34)> List.first(rs)["car"]
      %{"side" => "right", "signs" => ["SRB"]}
      iex(35)> List.first(rs)["flag"]
      "🇷🇸"
      iex(36)> List.first(rs)["flags"]
      %{
        "alt" => "The flag of Serbia is composed of three equal horizontal bands of red, blue and white. The coat of arms of Serbia is superimposed at the center of the field slightly towards the hoist side.",
        "png" => "https://flagcdn.com/w320/rs.png",
        "svg" => "https://flagcdn.com/rs.svg"
      }

  """
  def run(path) do
    baseUrl = "https://restcountries.com/v3.1/alpha/"

    client =
      Tesla.client([
        {Tesla.Middleware.BaseUrl, baseUrl},
        Tesla.Middleware.JSON
      ])

    Tesla.get!(client, path).body
  end
end
