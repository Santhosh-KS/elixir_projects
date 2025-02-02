import Config

config :baremetal, :ecto_repos, [Baremetal.Repo]

config :baremetal, Baremetal.Repo,
  database: "baremetal_db",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"
