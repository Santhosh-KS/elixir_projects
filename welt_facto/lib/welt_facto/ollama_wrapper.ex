# defmodule WeltFacto.User do
#   defstruct role: "user", content: ""
# end

# defmodule WeltFacto.Assistant do
#   defstruct role: "assistant", content: ""
# end

# defmodule WeltFacto.Tool do
#   defstruct role: "tool", content: ""
# end

# defmodule WeltFacto.System do
#   defstruct role: "system", content: ""
# end

defmodule WeltFacto.Message do
  defstruct role: "", content: "", tool_calls: []
end

defmodule WeltFacto.OllamaWrapper do
  defstruct model: "qwen3:0.6b",
            # model: "qwen3:8b-q4_K_M",
            # model: "gemma3",
            base_url: "http://localhost",
            port: 11444,
            # port: 11434,
            url: "/api",
            client: Ollama,
            stream: false,
            prompt: "Why the sky is blue?",
            messages: [],
            tools: []

  def client(%__MODULE__{} = module) do
    ollam_url = module.base_url <> ":" <> "#{module.port}" <> module.url
    IO.inspect(ollam_url, lable: "ollam_url")
    %{module | client: Ollama.init(ollam_url)}
  end

  def with_tools(%__MODULE__{} = module, tool) when is_map(tool) do
    # TODO: ++ on lists are not optimal fix it.
    %{module | tools: module.tools ++ [tool]}
  end

  def with_tools(%__MODULE__{} = module, tools) when is_list(tools) do
    %{module | tools: module.tools ++ tools}
  end

  def with_tools(%__MODULE__{} = module, _tool), do: module

  def with_messages(%__MODULE__{} = module, message) when is_map(message) do
    # IO.inspect("role: #{message.role}, content: #{message.content} ", lable: "Adding Message:")
    %{module | messages: module.messages ++ [message]}
  end

  def with_messages(%__MODULE__{} = module, _message), do: module

  def with_model(%__MODULE__{} = module, model) when is_binary(model) do
    %{module | model: model}
  end

  def with_model(%__MODULE__{} = module, _model), do: module

  def with_prompt(%__MODULE__{} = module, prompt) when is_binary(prompt) do
    %{module | prompt: prompt}
  end

  def with_prompt(%__MODULE__{} = module, _prompt), do: module

  def with_port(%__MODULE__{} = module, port) when is_integer(port) do
    %{module | port: port}
  end

  def with_port(%__MODULE__{} = module, _port), do: module

  def with_base_url(%__MODULE__{} = module, baseUrl) when is_binary(baseUrl) do
    %{module | base_url: baseUrl}
  end

  def with_base_url(%__MODULE__{} = module, _baseUrl), do: module

  @doc """
  iex(2)> c = OllamaWrapper.client(%WeltFacto.OllamaWrapper{})
  iex(3)> {:ok, out} = OllamaWrapper.completion(c)
  {:ok,
   %{
     "context" => [151644, 872, 198, 10234, 279, 12884, 374, 6303, 30, 151645,
     ....
     "response" => "<think>\nOkay, the user is asking why the sky is blue. I need to explain this in a clear and concise way. Let me start by recalling what I know about this. I remember that it has something to do with Rayleigh scattering. But wait, what exactly is Rayleigh scattering?\n\nSo, sunlight is white, but it's made up of different colors, each with different wavelengths. When sunlight enters Earth's atmosphere, the molecules and small particles in the air scatter the light. The scattering is more effective for shorter wavelengths, like blue and violet. But why blue and not violet?\n\nOh right, because the sun emits more blue light than violet, and our eyes are more sensitive to blue. Also, the atmosphere scatters the blue light in all directions, making the sky appear blue to us. But what about the other colors? Why don't we see them?\n\nWait, during sunrise or sunset, the sky turns red or orange. That's because the sunlight has to pass through more atmosphere, so the blue light is scattered away, leaving the longer wavelengths like red and orange. That makes sense.\n\nI should also mention that the human eye's sensitivity plays a role. Even though violet has a shorter wavelength, our eyes are less sensitive to it, so we perceive the sky as blue. Maybe include something about the composition of the atmosphere, like nitrogen and oxygen molecules, which are responsible for the scattering.\n\nBut I need to make sure the explanation is accurate. Let me check the key points: Rayleigh scattering, wavelength dependence, human eye sensitivity, and the effect of atmospheric depth. Also, clarify that the sky isn't actually blue, but the scattered light makes it appear that way. Maybe mention that the actual color of the sky is a result of the interaction between sunlight and the atmosphere.\n\nWait, what about the fact that the sun emits more blue light than violet? That's important. Also, the scattering of all the blue light in different directions is why the sky looks blue from all directions. If the sky were just the color of the sun, it would be white, but the scattering changes that.\n\nI should structure the answer to first explain the basic concept, then go into the details of Rayleigh scattering, the role of different wavelengths, human eye sensitivity, and the effect of scattering at different times of day. Make sure it's easy to follow and not too technical. Avoid jargon, but still accurate. Maybe use simple terms like \"scattering\" instead of \"Rayleigh scattering\" unless necessary. But the user might appreciate knowing the scientific term as well.\n\nAlso, check if there are any common misconceptions to address. For example, some people might think the sky is blue because of the Earth's color, but that's not the case. The blue color is due to the scattering of sunlight, not the Earth's surface.\n\nI think that's a solid structure. Now, put it all together in a clear, step-by-step explanation.\n</think>\n\nThe sky appears blue due to a phenomenon called **Rayleigh scattering**, which involves how sunlight interacts with the Earth's atmosphere. Here's a simplified explanation:\n\n1. **Sunlight Composition**: Sunlight is a mix of all visible colors, each with different wavelengths (violet, blue, green, yellow, orange, red). Shorter wavelengths (like blue and violet) scatter more easily than longer ones (like red).\n\n2. **Atmospheric Scattering**: When sunlight enters Earth's atmosphere, it collides with molecules (mainly nitrogen and oxygen) and small particles. These collisions scatter the light in all directions. **Shorter wavelengths (blue and violet) scatter more than longer ones**.\n\n3. **Why Blue, Not Violet**: While violet light scatters the most, the Sun emits more blue light than violet. Additionally, human eyes are more sensitive to blue than violet. This combination makes **blue** the dominant color we perceive in the sky.\n\n4. **Scattering in All Directions**: The scattered blue light reaches our eyes from all parts of the sky, creating the uniform blue appearance. This is why the sky looks blue even when the sun is behind you.\n\n5. **Sunrise/Sunse" <> ...,
     "total_duration" => 51997540417
   }}
   iex(4)> out["response"]
  """
  def completion(%__MODULE__{} = module) do
    Ollama.completion(module.client,
      model: module.model,
      prompt: module.prompt,
      stream: module.stream
    )
  end

  def print(%__MODULE__{} = module) do
    Enum.map(module.messages, fn v ->
      IO.inspect("role: #{v.role}, content: #{v.content} ")
    end)
  end

  def chat(%__MODULE__{} = module) do
    {:ok, resp} =
      Ollama.chat(
        module.client,
        model: module.model,
        messages: module.messages,
        # tools: [emoji_flag_tool]
        tools: module.tools
      )

    print(module)

    # %{client: c}
    %{module: module, response: resp}
  end
end
