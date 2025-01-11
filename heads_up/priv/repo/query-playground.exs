alias HeadsUp.Repo
alias HeadsUp.Incidents.Incident

import Ecto.Query

# iex(3)> query = from Incident, where: [status: :pending], order_by: :priority
query = Incident 
  |> where([status: :pending]) 
  |> order_by(:priority)
  |> Repo.all()
  |> IO.inspect

IO.puts("Next query-1")

q1 = Incident
  |> where([r], r.priority >= 2)
  |> Repo.all()
  |> IO.inspect

IO.puts("Next query-2")

q2 = Incident
  |> where([r], ilike(r.description, "%meow%"))
  |> Repo.all()
  |> IO.inspect
    
q3 = Incident
    |> where([r], ilike(r.name, "%in%"))
    |> order_by(desc: :name)
  |> Repo.all()
  |> IO.inspect
    
