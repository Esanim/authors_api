defmodule AuthorsApi.Repo.Migrations.AddOwnerIdToArticles do
  use Ecto.Migration

  def change do
    alter table(:articles) do
      add :owner_id, references(:authors)
    end
  end
end
