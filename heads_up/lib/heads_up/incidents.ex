alias HeadsUp.Incidents.Incident

alias HeadsUp.Incidents.Incident
alias HeadsUp.Repo
import Ecto.Query

defmodule HeadsUp.Incidents do
  def list_incidents do
    Repo.all(Incident)
  end

  def get_incident!(id) do
    Repo.get!(Incident, id)
  end

  def filer_incidents(filter) do
    Incident
    |> with_status(filter["status"])
    |> search_by(filter["q"])
    |> sort(filter["sort_by"])
    |> Repo.all()
  end

  defp with_status(query, status) when status in ~w(pending resolved canceled) do
    where(query, status: ^status)
  end

  defp with_status(query, _), do: query

  def search_by(query, q) when q in ["", nil], do: query

  def search_by(query, q) do
    where(query, [r], ilike(r.name, ^"%#{q}%"))
  end

  defp sort(query, "priority_asc") do
    order_by(query, asc: :priority)
  end

  defp sort(query, "priority_desc") do
    order_by(query, desc: :priority)
  end

  defp sort(query, _) do
    order_by(query, desc: :id)
  end

  def urgent_incidents(incident) do
    # Process.sleep(2000)

    Incident
    |> where(status: :pending)
    |> where([i], i.id != ^incident.id)
    |> order_by(asc: :priority)
    |> limit(3)
    |> Repo.all()
  end
end
