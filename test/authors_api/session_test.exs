defmodule AuthorsApi.SessionTest do
  use AuthorsApi.DataCase

  alias AuthorsApi.Session

  @valid_attrs %{author_id: "1"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Session.changeset(%Session{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Session.changeset(%Session{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "create_changeset with valid attributes" do
    changeset = Session.registration_changeset(%Session{}, @valid_attrs)
    assert changeset.changes.token
    assert changeset.valid?
  end

  test "create_changeset with invalid attributes" do
    changeset = Session.registration_changeset(%Session{}, @invalid_attrs)
    refute changeset.valid?
  end
end

