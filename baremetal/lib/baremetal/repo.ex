defmodule Baremetal.Repo do
  use Ecto.Repo,
    otp_app: :baremetal,
    adapter: Ecto.Adapters.Postgres
end
