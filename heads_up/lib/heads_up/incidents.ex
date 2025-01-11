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

  def filer_incidents do
    Incident
    |> where(status: :resolved)
    |> where([r], ilike(r.name, "%in%"))
    |> order_by(desc: :name)
    |> Repo.all()
  end

  def urgent_incidents(incident) do
    Incident
    |> where(status: :pending)
    |> where([i], i.id != ^incident.id)
    |> order_by(asc: :priority)
    |> limit(3)
    |> Repo.all()
  end
end
