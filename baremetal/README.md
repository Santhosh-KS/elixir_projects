# Baremetal

## How did I setup this project?
Step by step instructions to setup bare minimum ecto project from scratch.

### Step-1

```sh
$ mix new baremetal --sup
* creating README.md
* creating .formatter.exs
* creating .gitignore
* creating mix.exs
* creating lib
* creating lib/baremetal.ex
* creating lib/baremetal/application.ex
* creating test
* creating test/test_helper.exs
* creating test/baremetal_test.exs

Your Mix project was created successfully.
You can use "mix" to compile it, test it, and more:

    cd baremetal
    mix test
```

### Step-2

Add dependencies in `mix.exs` file

```sh
# file: mix.exs
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:ecto_sql, "~> 3.12"},
      {:postgrex, "~> 0.19.3"}
    ]
  end
```
### Setp-3
Creating Your Repo Module `lib/baremetal/repo.ex`

```sh
defmodule Baremetal.Repo do
  use Ecto.Repo,
    otp_app: :baremetal, # --> This name we will use it in the config/config.exs
    adapter: Ecto.Adapters.Postgres
end
```

### Step-4

Configure the database 

```elixir
import Config

config :baremetal, Baremetal.Repo,
  database: "baremetal_db",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"
```

### Step-5
For Ecto’s mix tasks to be able to find the repository, we also need to add the
following line to `config/config.exs`


```elixir
config :my_app, :ecto_repos, [Baremetal.Repo]
```

### Step-6
Adding Ecto to the Supervision Tree `lib/baremetal/application.ex`

```elixir
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Baremetal.Worker.start_link(arg)
      # {Baremetal.Worker, arg}
      Baremetal.Repo
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Baremetal.Supervisor]
    Supervisor.start_link(children, opts)
  end
```
