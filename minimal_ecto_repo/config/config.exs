use Mix.Config

config :music_db, :ecto_repos, [MusicDB.Repo]

config :music_db, MusicDb.Repo,
  database: "music_db",
  username: "mygsuser",
  password: "pa55word",
  hostname: "localhost"
