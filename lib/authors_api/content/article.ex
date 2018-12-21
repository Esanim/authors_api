defmodule AuthorsApi.Content.Article do
  use Ecto.Schema
  import Ecto.Changeset


  schema "articles" do
    field :body, :string
    field :description, :string
    field :published_date, :utc_datetime
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(article, attrs) do
    article
    |> cast(attrs, [:title, :description, :body, :published_date])
    |> validate_required([:title, :description, :body, :published_date])
  end
end
