defmodule Meow.Meerkats do
  import Ecto.Query, warn: false
  alias Meow.Repo
  alias Meow.Meerkats.Meerkat

  def list_meerkats do
    Repo.all(Meerkat)
  end
end
