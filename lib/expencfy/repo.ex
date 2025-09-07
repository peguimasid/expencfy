defmodule Expencfy.Repo do
  use Ecto.Repo,
    otp_app: :expencfy,
    adapter: Ecto.Adapters.Postgres
end
