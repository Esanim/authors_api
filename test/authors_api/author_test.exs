defmodule AuthorsApi.AuthorTest do
  use AuthorsApi.DataCase

  alias AuthorsApi.Author
  alias AuthorsApi.Repo

  @valid_attrs %{first_name: "James", last_name: "Bagzynski", age: 18}

  test "changeset with valid attributes" do
    changeset = Author.changeset(%Author{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset, last_name is too short" do
    changeset = Author.changeset(
      %Author{}, Map.put(@valid_attrs, :last_name, "Cd")
    )
    refute changeset.valid?
  end

  test "changeset, first_name is empty" do
    changeset = Author.changeset(
      %Author{}, Map.put(@valid_attrs, :first_name, "")
    )
    refute changeset.valid?
  end

  test "changeset, incorrect age" do
    changeset = Author.changeset(
      %Author{}, Map.put(@valid_attrs, :age, 0)
    )
    assert {:error, %Ecto.Changeset{}} = Repo.insert(changeset)
  end

end
