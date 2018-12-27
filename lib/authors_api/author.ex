defmodule AuthorsApi.Author do
  use Ecto.Schema
  import Ecto.Changeset

  schema "authors" do
    field :first_name, :string
    field :last_name, :string
    field :age, :integer

    timestamps()
  end

  @doc false
  def changeset(author, attrs \\ %{}) do
    author
    |> cast(attrs, [:first_name, :last_name, :age])
    |> unique_constraint(:unique_name, name: :index_full_name)
    |> validate_required([:first_name, :last_name, :age])
    |> validate_length(:first_name, min: 3, max: 30)
    |> validate_length(:last_name, min: 3, max: 30)
    |> validate_number(:age, greater_than: 12)
    |> validate_number(:age, less_than: 99)
  end

end
