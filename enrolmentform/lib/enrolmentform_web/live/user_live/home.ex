defmodule EnrolmentformWeb.UserLive.Home do
  use EnrolmentformWeb, :live_view

  def render(assigns) do
    ~H"""
    <section class="bg-gradient-to-r from-blue-500 to-purple-600 py-20 px-4 ">
      <div class="max-w-6xl mx-auto flex flex-col md:flex-row items-center justify-between">
        <div class="md:w-1/2 text-white mb-10 md:mb-0">
          <h1 class="text-4xl md:text-5xl font-bold mb-4">
            Unlock AI's Power: Privacy-First Developer Workshop
          </h1>
          <p class="text-xl mb-8">
            Dive into AI's frontier: where innovation meets code, and your privacy remains sacred in this developer-focused revolution.
          </p>
          <.register_button />
        </div>
      </div>
    </section>
    <section class="py-16 bg-gray-222">
      <div class="max-w-6xl mx-auto px-4">
        <h2 class="text-3xl font-bold mb-6 text-center">About the Workshop</h2>
        <p class="text-gray-100 mb-4">
          In this rapidly evolving AI age 🚀, mastering AI workflows has become essential for developers, but privacy concerns continue to grow.
          <p class="text-gray-100 mb-4">
            🔒 As AI tools collect and process vast amounts of sensitive data, protecting user privacy has become a critical challenge.
          </p>
        </p>
        <p class="text-gray-100 mb-4">
          🛡️ This 1-hour workshop focuses specifically on how open-source AI tools can be leveraged to maintain privacy while building powerful applications.
        </p>
        <p class="text-gray-100 mb-4">
          🤖 We'll explore privacy-preserving techniques using open frameworks that keep your data under your control, eliminating reliance on third-party cloud services that might compromise confidentiality.
        </p>

        <p class="text-gray-100 mb-4">
          💻 You'll learn practical approaches to implement local model deployment and use the latest and greatest models released almost every day!
        </p>
        <p class="text-gray-100 mb-4">
          📈 By the end of this workshop, you'll be equipped with the knowledge to build AI systems that respect user privacy while delivering innovative solutions.
        </p>
        <p class="text-gray-100 mb-4">
          🎓 Join us to discover how open-source tools can revolutionize your AI development with privacy at its core! 🌟
        </p>
        <p class="text-gray-100 py-4 mt-4">
          Here are some of the free/opensource tools which we will be using in this workshop.
          <li class="mb-3 flex items-center transform hover:scale-105 transition-transform duration-300 bg-gray-800 rounded-lg p-4 border-l-4 border-blue-400">
            <div class="mr-3 text-blue-400 text-xl">🤖</div>
            <a
              href="https://ollama.com"
              target="_blank"
              rel="noopener noreferrer"
              class="text-blue-400 hover:text-blue-300 font-semibold"
            >
              Ollama - Run LLMs locally for free!
            </a>
          </li>
          <li class="mb-3 flex items-center transform hover:scale-105 transition-transform duration-300 bg-gray-800 rounded-lg p-4 border-l-4 border-purple-400">
            <div class="mr-3 text-purple-400 text-xl">💻</div>
            <a
              href="https://zed.dev"
              target="_blank"
              rel="noopener noreferrer"
              class="text-blue-400 hover:text-blue-300 font-semibold"
            >
              Zed IDE - An open source code editor with AI assistance for free!
            </a>
          </li>
          <li class="mb-3 flex items-center transform hover:scale-105 transition-transform duration-300 bg-gray-800 rounded-lg p-4 border-l-4 border-green-400">
            <div class="mr-3 text-green-400 text-xl">📱</div>
            <a
              href="https://msty.app"
              target="_blank"
              rel="noopener noreferrer"
              class="text-blue-400 hover:text-blue-300 font-semibold"
            >
              Msty - Private AI messaging for free!
            </a>
          </li>
        </p>
        <p class="text-gray-100 py-4 mt-4">
          In this hands-on workshop, you'll discover practical techniques for integrating AI tools into your daily development workflow, significantly boosting your productivity while maintaining complete data privacy.
        </p>
      </div>
    </section>
    <section class="bg-gradient-to-r from-purple-600 to-blue-500  py-10 px-4 ">
      <div class="flex justify-center">
        <.register_button />
      </div>
    </section>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_event("register", _params, socket) do
    socket =
      socket |> push_navigate(to: "/users/new")

    {:noreply, socket}
  end

  defp register_button(assigns) do
    ~H"""
    <div class="flex flex-col sm:flex-row gap-4">
      <!-- This div uses flexbox layout that stacks items vertically (flex-col) on small screens,
      but switches to horizontal layout (flex-row) on screens sm breakpoint and larger.
      The gap-4 adds spacing of 1rem between flex items. -->
      <button
        class="w-full bg-white text-blue-600 font-bold py-3 px-6 rounded-lg hover:bg-blue-100 transition duration-300"
        phx-click="register"
      >
        Register Now
      </button>
    </div>
    """
  end
end
