defmodule AuthorsApi.Repo.Migrations.CreateAuthor do
  use Ecto.Migration

    def change do
      create table(:authors) do
        add :first_name, :string, null: false
        add :last_name, :string, null: false
        add :age, :integer, null: false

        timestamps()
      end

    end
end
