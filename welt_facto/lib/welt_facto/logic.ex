defmodule WeltFacto.Logic do
  alias WeltFacto.Infos
  alias WeltFacto.OllamaWrapper

  @doc """
  iex(19)> WeltFacto.Logic.question("can you tell me more about the Egypt flag? is there any emoji for it?")
  %{
    module: %WeltFacto.OllamaWrapper{
      model: "qwen3:0.6b",
      base_url: "http://localhost",
      port: 11444,
      url: "/api",
      client: %Ollama{
        req: %Req.Request{
          method: :get,
          url: URI.parse(""),
          headers: %{"user-agent" => ["ollama-ex/0.8.0"]},
          body: nil,
          options: %{
            receive_timeout: 60000,
            base_url: "http://localhost:11444/api"
          },
          halted: false,
          adapter: &Req.Steps.run_finch/1,
          request_steps: [
            put_user_agent: &Req.Steps.put_user_agent/1,
            compressed: &Req.Steps.compressed/1,
            encode_body: &Req.Steps.encode_body/1,
            put_base_url: &Req.Steps.put_base_url/1,
            auth: &Req.Steps.auth/1,
            put_params: &Req.Steps.put_params/1,
            put_path_params: &Req.Steps.put_path_params/1,
            put_range: &Req.Steps.put_range/1,
            cache: &Req.Steps.cache/1,
            put_plug: &Req.Steps.put_plug/1,
            compress_body: &Req.Steps.compress_body/1,
            checksum: &Req.Steps.checksum/1,
            put_aws_sigv4: &Req.Steps.put_aws_sigv4/1
          ],
          response_steps: [
            retry: &Req.Steps.retry/1,
            handle_http_errors: &Req.Steps.handle_http_errors/1,
            redirect: &Req.Steps.redirect/1,
            decompress_body: &Req.Steps.decompress_body/1,
            verify_checksum: &Req.Steps.verify_checksum/1,
            decode_body: &Req.Steps.decode_body/1,
            output: &Req.Steps.output/1
          ],
          error_steps: [retry: &Req.Steps.retry/1],
          private: %{}
        }
      },
      stream: false,
      prompt: "Why the sky is blue?",
      messages: [
        %{
          role: "user",
          content: "can you tell me more about the Egypt flag? is there any emoji for it?"
        },
        %{
          role: "tool",
          content: "",
          tool_calls: [
            %{
              "function" => %{
                "arguments" => %{"country" => "EG"},
                "name" => "emoji_flag"
              }
            }
          ]
        },
        %{
          role: "tool",
          content: "Here is the emoji flag for the country you asked for 🇪🇬"
        }
      ],
      tools: [
        %{
          function: %{
            name: "emoji_flag",
            description: "Fetches the emoji flag for a given country's alpha-3 or alpha-2 code",
            parameters: %{
              type: "object",
              required: ["country"],
              properties: %{
                country: %{
                  type: "string",
                  description: "alpha-3 code of a specific country"
                }
              }
            }
          },
          type: "function"
        }
      ]
    },
    response: %{
      "created_at" => "2025-05-10T16:23:18.914372Z",
      "done" => true,
      "done_reason" => "stop",
      "eval_count" => 122,
      "eval_duration" => 941783625,
      "load_duration" => 21963250,
      "message" => %{
        "content" => "<think>\nOkay, the user asked about the Egypt flag and if there's an emoji. I need to check if the function is available. The tools provided include an emoji_flag function that takes a country's alpha-3 code. Egypt's alpha-3 code is 'EGY'. So I should call that function with 'EGY' as the argument. The user already confirmed there's an emoji, so the response should include that information.\n</think>\n\nThe Egypt flag is represented by the emoji 🇪🇬. This emoji symbolizes the country's identity and is part of its national flag design.",
        "role" => "assistant"
      },
      "model" => "qwen3:0.6b",
      "prompt_eval_count" => 194,
      "prompt_eval_duration" => 30802917,
      "total_duration" => 997251166
    }
  }
  """

  def question(q) when is_binary(q) do
    # IO.inspect("q-1")

    emoji_flag_tool = %{
      type: "function",
      function: %{
        name: "emoji_flag",
        description: "Fetches the emoji flag for a given country's alpha-3 or alpha-2 code",
        parameters: %{
          type: "object",
          properties: %{
            country: %{
              type: "string",
              description: "alpha-3 code of a specific country"
            }
          },
          required: ["country"]
        }
      }
    }

    msg = %{role: "user", content: q}

    oc =
      OllamaWrapper.client(%OllamaWrapper{})
      |> OllamaWrapper.with_tools(emoji_flag_tool)
      |> OllamaWrapper.with_messages(msg)

    # IO.inspect("q-2")

    %{module: module, response: resp} = OllamaWrapper.chat(oc)
    tool = resp["message"]["tool_calls"]

    if tool != nil do
      # IO.inspect("q-if-1")
      tool_msg = %{role: "tool", content: "", tool_calls: tool}

      module =
        module
        |> OllamaWrapper.with_messages(tool_msg)

      # IO.inspect("q-if-2")

      # intercepting the tool call and handling it appropriately
      content = handle_tool_call(:emoji, List.first(tool))
      # IO.inspect("q-if-3")
      tool_content = %{
        role: "tool",
        content: content
      }

      # IO.inspect("q-if-4")

      module =
        module
        |> OllamaWrapper.with_messages(tool_content)

      # IO.inspect("q-if-5")

      # OllamaWrapper.chat(module, content)

      %{module: module, response: resp} = OllamaWrapper.chat(module)
      # %{module: module, response: resp} = OllamaWrapper.chat(module, q)
      # IO.inspect("q-if-6")
      %{module: module, response: resp}
    else
      # IO.inspect("q-else-1")
      %{module: module, response: resp}
      resp
    end
  end

  def details_tool(q) when is_binary(q) do
    IO.inspect("DT-1")

    description = """
    This function is capable of fetching the following details about a country.
    | field                  | Info                                                                                            |
    |------------------------|-------------------------------------------------------------------------------------------------|
    | alpha2Code / cca2      | ISO 3166-1 alpha-2 two-letter country codes                                                     |
    | alpha3Code / cca3      | ISO 3166-1 alpha-3 three-letter country codes                                                   |
    | altSpellings           | Alternate spellings of the country name                                                         |
    | area                   | Geographical size. (Units like Sq Km or Sq Meteris not specified.Hence, do not share the unit for thie field)|
    | borders                | Shares Border with countries. This data is given as list of Alpha-2 or Alpha-3 codes.           |
    | callingCodes / idd     | International dialing codes for telephone/fax uses                                              |
    | capital                | Capital cities                                                                                  |
    | car > signs            | Car distinguised (oval) signs                                                                   |
    | car > side             | Car driving side                                                                                |
    | cioc                   | Code of the International Olympic Committee                                                     |
    | coatOfArms             | provide png and svg [MainFacts.com](https://mainfacts.com/coat-of-arms-countries-world)         |
    | continents             | List of continents the country is on                                                            |
    | currencies             | List of all currencies used by the given conuntry                                               |
    | demonyms (m/f)         | Genderized inhabitants of the country                                                           |
    | independent            | ISO 3166-1 independence status (the country is considered a sovereign state or not)             |
    | fifa                   | FIFA code                                                                                       |
    | flag                   | flag of the country in emoji form.                                                              |
    | flags                  | provides the png and svg images links of the flag from [Flagpedia](https://flagpedia.net/)      |
    | gini                   | Worldbank [Gini](https://data.worldbank.org/indicator/SI.POV.GINI) index                        |
    | landlocked             | Landlocked country                                                                              |
    | languages              | List of official languages                                                                      |
    | latlng                 | Latitude and longitude. (Here do not specify the city. As data is not complete)                                                                          |
    | maps                   | Provides Link to Google maps and Open Street maps                                                        |
    | name                   | Country name                                                                                    |
    | name > official/common | Official and common country name                                                                |
    | nativeName > official/common| Official and common native country name                                                         |
    | population             | Country population                                                                              |
    | region                 | UN [demographic regions](https://unstats.un.org/unsd/methodology/m49/)                          |
    | status                 | ISO 3166-1 assignment status                                                                    |
    | subregion              | UN [demographic subregions](https://unstats.un.org/unsd/methodology/m49/)                       |
    | topLevelDomain / tld   | Internet top level domains, for example: ".de" -> Germany, ".in" -> India etc.                                                                      |
    | unMember               | UN Member status                                                                                |
    """

    description_1 = """
    This function is will be able to get the following details about a country.
     alpha-2 Code            ISO 3166-1 alpha-2 two-letter country codes
     alpha-3 Code            ISO 3166-1 alpha-3 three-letter country codes
     altSpellings            Alternate spellings of the country name
     area                    Geographical size. (Units like Sq Km or Sq Meteris not specified.Hence, do not share the unit for the field)
     borders                 Shares Border with countries. This data is given as list of Alpha-2 or Alpha-3 codes.
     callingCodes / idd      International dialing codes for telephone/fax uses
     capital                 Capital cities
     car > signs             Car distinguised (oval) signs
     car > side              Car driving side
     cioc                    Code of the International Olympic Committee
     coatOfArms              provide png and svg [MainFacts.com](https://mainfacts.com/coat-of-arms-countries-world)
     continents              List of continents the country is on
     currencies              List of all currencies used by the given conuntry
     demonyms (m/f)          Genderized inhabitants of the country
     independent             ISO 3166-1 independence status (the country is considered a sovereign state or not)
     fifa                    FIFA code
     flag                    flag of the country in emoji form.
     flags                   provides the png and svg images links of the flag from [Flagpedia](https://flagpedia.net/)
     gini                    Worldbank [Gini](https://data.worldbank.org/indicator/SI.POV.GINI) index
     landlocked              Landlocked country
     languages               List of official languages
     latlng                  Latitude and longitude. (Here do not specify the city. As data is not complete)
     maps                    Provides Link to Google maps and Open Street maps
     name                    Country name
     name > official/common  Official and common country name
     nativeName > official/common Official and common native country name
     population              Country population
     region                  UN [demographic regions](https://unstats.un.org/unsd/methodology/m49/)
     status                  ISO 3166-1 assignment status
     subregion               UN [demographic subregions](https://unstats.un.org/unsd/methodology/m49/)
     topLevelDomain / tld    Internet top level domains, for example: ".de" -> Germany, ".in" -> India etc.
     unMember                UN Member status

    """

    country_details_tool = %{
      type: "function",
      function: %{
        name: "emoji_flag",
        description: description_1,
        parameters: %{
          type: "object",
          properties: %{
            country: %{
              type: "string",
              description: "Important note: provide only Alpha-3 code of a specific country"
            }
          },
          required: ["country"]
        }
      }
    }

    msg = %{role: "user", content: q}

    IO.inspect("DT-2")

    ollama_client =
      OllamaWrapper.client(%OllamaWrapper{})
      |> OllamaWrapper.with_tools(country_details_tool)
      |> OllamaWrapper.with_messages(msg)

    IO.inspect("DT-3")
    %{module: module, response: resp} = OllamaWrapper.chat(ollama_client)
    tool = resp["message"]["tool_calls"]
    IO.inspect("DT-4")

    if tool != nil do
      IO.inspect("DT-if-5")
      tool_msg = %{role: "tool", content: "", tool_calls: tool}

      module =
        module
        |> OllamaWrapper.with_messages(tool_msg)

      IO.inspect("DT-if-6")

      # intercepting the tool call and handling it appropriately
      content = handle_tool_call(:details, List.first(tool))
      IO.inspect("DT-if-7")

      tool_content = %{
        role: "tool",
        content: content
      }

      IO.inspect("DT-if-8")

      module =
        module
        |> OllamaWrapper.with_messages(tool_content)

      IO.inspect("DT-if-9")

      # OllamaWrapper.chat(module, content)

      %{module: module, response: resp} = OllamaWrapper.chat(module)
      # %{module: module, response: resp} = OllamaWrapper.chat(module, q)
      IO.inspect("DT-if-10")
      %{module: module, response: resp}
    else
      IO.inspect("DT-else-1")
      %{module: module, response: resp}
      resp
    end
  end

  defp handle_tool_call(:emoji, tool) when is_map(tool) do
    # IO.inspect("htc-1")
    code = tool["function"]["arguments"]["country"]
    # fnc = tool["function"]["name"]
    handle_emoji_flag(code)
  end

  defp handle_tool_call(:details, tool) when is_map(tool) do
    IO.inspect("htc for details -1")
    code = tool["function"]["arguments"]["country"]
    # fnc = tool["function"]["name"]
    handle_details(code)
  end

  defp handle_emoji_flag(code) do
    # IO.inspect("hef-1")
    base_url = "https://restcountries.com/v3.1/"
    c = Infos.client(base_url: base_url, country_code: code)
    "Here is the emoji flag for the country you asked for #{Infos.emoji_flag(c)}"
  end

  defp handle_details(code) do
    IO.inspect("hed-1")
    base_url = "https://restcountries.com/v3.1/"
    c = Infos.client(base_url: base_url, country_code: code)
    details = Infos.details(c)
    "Here is the all the details of the country you asked for #{details}"
  end
end
