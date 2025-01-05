defmodule HeadsUpWeb.TipsController do
  use HeadsUpWeb, :controller

  def tips(conn, _params) do
    emojis = ~w(💚 💜 💙) |> Enum.random() |> String.duplicate(5)
    rules = HeadsUp.Tips.list_tips()
    render(conn, :tips, emojis: emojis, mytips: rules)
  end
end
