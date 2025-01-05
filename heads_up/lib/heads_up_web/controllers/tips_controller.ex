defmodule HeadsUpWeb.TipsController do
  use HeadsUpWeb, :controller

  def tips(conn, _params) do
    emojis = ~w(💚 💜 💙) |> Enum.random() |> String.duplicate(1..5 |> Enum.random())
    rules = HeadsUp.Tips.list_tips()
    render(conn, :index, emojis: emojis, mytips: rules)
  end

  def show(conn, %{"id" => id}) do
    tip = HeadsUp.Tips.get_tip(id)
    render(conn, :show, tip: tip)
  end
end
