defmodule Sb.Repo do
  use Ecto.Repo,
    otp_app: :sb,
    adapter: Ecto.Adapters.Postgres
end
