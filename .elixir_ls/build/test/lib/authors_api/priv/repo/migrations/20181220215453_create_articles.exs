defmodule AuthorsApi.Repo.Migrations.CreateArticles do
  use Ecto.Migration

  def change do
    create table(:articles) do
      add :title, :string, null: false
      add :description, :string
      add :body, :string, null: false
      add :published_date, :utc_datetime, null: false

      timestamps()
    end

  end
end
