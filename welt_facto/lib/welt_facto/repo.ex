defmodule WeltFacto.Repo do
  use Ecto.Repo,
    otp_app: :welt_facto,
    adapter: Ecto.Adapters.Postgres
end
