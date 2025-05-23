defmodule WeltFacto.Infos do
  defstruct base_url: "",
            url: "",
            country_code: "",
            req: %Req.Request{}

  def client(opts) do
    %WeltFacto.Infos{
      req: Req.new(base_url: opts[:base_url]),
      base_url: opts[:base_url],
      country_code: opts[:country_code]
    }
  end

  def flags(%WeltFacto.Infos{} = data) do
    url = "/alpha/" <> data.country_code
    caller("flags", request: data.req, url: url)
  end

  def emoji_flag(%WeltFacto.Infos{} = data) do
    url = "/alpha/" <> data.country_code
    caller("flag", request: data.req, url: url, cca3: data.country_code)
  end

  def details(%WeltFacto.Infos{} = data) do
    url =
      "/all?fields=flag,coatOfArms,car,cca3,cca2,ccn3,cioc,tld,currencies,languages,flags,maps,latlng,population,area,unMember,altSpellings,borders,idd,demonyms"

    caller("currencies", request: data.req, url: url, cca3: data.country_code)
  end

  defp caller(str, request: request, url: url, cca3: cca3) do
    case Req.get(request, url: url) do
      {:ok, resp} ->
        IO.inspect("Country cca3: #{cca3}")
        # IO.inspect(resp.body, label: "CALLER:")
        item = Enum.filter(resp.body, fn v -> v["cca3"] == cca3 end)

        # Enum.filter(xs, fn x -> x["cca3"] == "TON" end)
        if List.first(item) != nil do
          # if List.first(resp.body) != nil do
          IO.inspect(item)
          "dummy value"
          # List.first(resp.body)[str]
        else
          "Something went wrong with body parsing..."
        end

      # |> Jason.encode()

      {:error, reason} ->
        "Not able to get the #{reason} error"
        #   [%{error: reason, message: "Not able to get the #{url} details"}] |> Jason.encode()
    end
  end

  # Implement support for these endpoints
  # https://restcountries.com/v3.1/all
  # https://restcountries.com/v3.1/name/{name}
  # https://www.iban.com/country-codes --> gives you the alpha 2 and alpha 3 codes list
  # https://restcountries.com/v3.1/alpha/{code}  --> code can be cca2, ccn3, cca3 or cioc country code (yes, any!)
  # https://restcountries.com/v3.1/alpha?codes={code},{code},{code}
  # https://restcountries.com/v3.1/alpha?codes=170,no,est,pe
  # https://restcountries.com/v3.1/currency/{currency}
  # https://restcountries.com/v3.1/demonym/{demonym}
  # Demonym
  # Now you can search by how a citizen is called.
  # https://restcountries.com/v3.1/demonym/peruvian
  # Search by language code
  # https://restcountries.com/v3.1/lang/{language}
  # https://restcountries.com/v3.1/lang/cop
  # https://restcountries.com/v3.1/lang/spanish
  # search by region
  # https://restcountries.com/v3.1/region/{region}
  # https://restcountries.com/v3.1/region/europe
  # search by sub region
  # https://restcountries.com/v3.1/subregion/{subregion}
  # https://restcountries.com/v3.1/subregion/Northern Europe
  # https://restcountries.com/v3.1/translation/{translation}
  # You can search by any translation name
  # https://restcountries.com/v3.1/translation/germany
  # https://restcountries.com/v3.1/translation/alemania
  # https://restcountries.com/v3.1/translation/Saksamaa
  # Filter Response
  # You can filter the output of your request to include only the specified fields.
  # https://restcountries.com/v3.1/{service}?fields={field},{field},{field}
  # https://restcountries.com/v3.1/all?fields=name,capital,currencies
  #
  # Other links from the source code
  # https://gitlab.com/restcountries/restcountries/-/blob/master/FIELDS.md?ref_type=heads --> Source code
  # https://unstats.un.org/unsd/methodology/m49/ --> Maping M49 codes with ALpha3 codes
  # https://mainfacts.com/coat-of-arms-countries-world --> provides the images link
  # https://www.iban.com/country-codes --> gives you the alpha 2 and alpha 3 codes list
end
