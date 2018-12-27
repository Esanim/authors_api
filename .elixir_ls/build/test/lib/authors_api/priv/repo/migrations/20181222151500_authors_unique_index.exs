defmodule AuthorsApi.Repo.Migrations.AuthorsUniqueIndex do
  use Ecto.Migration

  def change do
    create unique_index(:authors, [:first_name, :last_name], name: :index_full_name)
  end
end
