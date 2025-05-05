defmodule Enrolmentform.CoursesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Enrolmentform.Courses` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "some email",
        name: "some name"
      })
      |> Enrolmentform.Courses.create_user()

    user
  end
end
