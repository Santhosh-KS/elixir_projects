defmodule SbWeb.Storybook do
  use PhoenixStorybook,
    otp_app: :sb_web,
    content_path: Path.expand("../../storybook", __DIR__),
    title: "Storybook for sb APP",
    # assets path are remote path, not local file-system paths
    css_path: "/assets/storybook.css",
    js_path: "/assets/storybook.js",
    sandbox_class: "sb-web"
end
