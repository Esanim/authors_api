defmodule AuthorsApi.Repo do
  use Ecto.Repo,
    otp_app: :authors_api,
    adapter: Ecto.Adapters.Postgres
end
