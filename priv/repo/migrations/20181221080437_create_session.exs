defmodule AuthorsApi.Repo.Migrations.CreateSession do
  use Ecto.Migration

  def change do
    create table(:sessions) do
      add :token, :string
      add :author_id, references(:authors, on_delete: :nothing)

      timestamps()
    end

    create index(:sessions, [:author_id])
    create index(:sessions, [:token])
  end
end
