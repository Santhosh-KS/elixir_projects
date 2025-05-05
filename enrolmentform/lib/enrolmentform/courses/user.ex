defmodule Enrolmentform.Courses.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :email, :string
    field :linkedInUrl, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :linkedInUrl])
    |> validate_name()
    |> validate_email()
    |> validate_linkedIn_url()
  end

  defp validate_name(changeset) do
    changeset
    |> validate_required([:name])
    |> validate_length(:name, min: 3, max: 100)
  end

  defp validate_email(changeset) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/)
    |> unsafe_validate_unique(:email, Enrolmentform.Repo)
    |> unique_constraint(:email)
  end

  defp validate_linkedIn_url(changeset) do
    changeset
    |> validate_required([:linkedInUrl])
    |> validate_format(
      :linkedInUrl,
      ~r/^(https?:\/\/)?(www\.)?linkedin\.com\/in\/[a-zA-Z0-9\-_]{5,30}\/$/
    )
    |> unsafe_validate_unique(:linkedInUrl, Enrolmentform.Repo)
    |> unique_constraint(:linkedInUrl)
  end
end
