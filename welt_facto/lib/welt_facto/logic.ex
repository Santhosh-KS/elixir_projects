defmodule WeltFacto.Logic do
  alias WeltFacto.Infos
  alias WeltFacto.OllamaWrapper

  def question(q) when is_binary(q) do
    # IO.inspect("q-1")

    emoji_flag_tool = %{
      type: "function",
      function: %{
        name: "emoji_flag",
        description: "Fetches the emoji flag for a given country alpha-3 code",
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

    oc = OllamaWrapper.client(%OllamaWrapper{}) |> OllamaWrapper.with_tools(emoji_flag_tool)
    # IO.inspect("q-2")

    %{module: module, response: resp} = OllamaWrapper.chat(oc, q)
    tool = resp["message"]["tool_calls"]

    if tool != nil do
      # IO.inspect("q-if-1")
      msg = %{role: "tool", content: "", tool_calls: tool}

      module =
        module
        |> OllamaWrapper.with_messages(msg)

      # IO.inspect("q-if-2")

      # intercepting the tool call and handling it appropriately
      content = handle_tool_call(List.first(tool))
      # IO.inspect("q-if-3")
      msg = %{role: "tool", content: content}

      # IO.inspect("q-if-4")

      module =
        module
        |> OllamaWrapper.with_messages(msg)

      # IO.inspect("q-if-5")

      # OllamaWrapper.chat(module, content)

      %{module: module, response: resp} = OllamaWrapper.chat(module, q)
      # IO.inspect("q-if-6")
      %{module: module, response: resp}
    else
      # IO.inspect("q-else-1")
      %{module: module, response: resp}
      resp
    end
  end

  defp handle_tool_call(tool) when is_map(tool) do
    # IO.inspect("htc-1")
    code = tool["function"]["arguments"]["country"]
    fnc = tool["function"]["name"]
    handle_emoji_flag(code, fnc)
  end

  defp handle_emoji_flag(code, _fnc) do
    # IO.inspect("hef-1")
    base_url = "https://restcountries.com/v3.1/"
    c = Infos.client(base_url: base_url, country_code: code)
    Infos.emoji_flag(c)
  end
end
