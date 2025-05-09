defmodule WeltFacto.OllamaWrapper do
  defstruct model: "gemma3",
            base_url: "http://localhost",
            port: 11444,
            # port: 11434,
            url: "/api",
            client: Ollama,
            stream: true,
            prompt: "Why the sky is blue?"

  @doc """
  iex(2)> c = OllamaWrapper.client(%WeltFacto.OllamaWrapper{})
  %WeltFacto.OllamaWrapper{
    model: "gemma3",
    base_url: "http://localhost",
    port: 11444,
    url: "/api",
    client: %Ollama{
      req: %Req.Request{
        method: :get,
        url: URI.parse(""),
        headers: %{"user-agent" => ["ollama-ex/0.8.0"]},
        body: nil,
        options: %{receive_timeout: 60000, base_url: "http://localhost:11444/api"},
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
    stream: true,
    prompt: "Why the sky is blue?"
  }
  """
  def client(%__MODULE__{} = module) do
    ollam_url = module.base_url <> ":" <> "#{module.port}" <> module.url
    IO.inspect(ollam_url, lable: "ollam_url")
    %{module | client: Ollama.init(ollam_url)}
  end

  def with_model(%__MODULE__{} = module, model) when is_binary(model) do
    %{module | model: model}
  end

  def with_prompt(%__MODULE__{} = module, prompt) when is_binary(prompt) do
    %{module | prompt: prompt}
  end

  def with_port(%__MODULE__{} = module, port) when is_integer(port) do
    %{module | port: port}
  end

  def with_base_url(%__MODULE__{} = module, baseUrl) when is_binary(baseUrl) do
    %{module | base_url: baseUrl}
  end

  def completion(%__MODULE__{} = module) do
    Ollama.completion(module.client,
      model: module.model,
      prompt: module.prompt,
      stream: module.stream
    )
  end
end
