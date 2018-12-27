defmodule AuthorsApi.ArticleTest do
  use AuthorsApi.DataCase

  alias AuthorsApi.Article

  @valid_attrs %{
    body: "some body",
    description: "some description",
    published_date: "2010-04-17T14:00:00Z",
    title: "some title"
  }

  test "changeset with valid attributes" do
    changeset = Article.changeset(%Article{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset, title is empty" do
    changeset =
      Article.changeset(
        %Article{},
        Map.put(@valid_attrs, :title, "")
      )

    refute changeset.valid?
  end

  test "changeset, description is empty" do
    changeset =
      Article.changeset(
        %Article{},
        Map.put(@valid_attrs, :description, "")
      )

    refute changeset.valid?
  end

  test "changeset, body is empty" do
    changeset =
      Article.changeset(
        %Article{},
        Map.put(@valid_attrs, :body, "")
      )

    refute changeset.valid?
  end

  test "changeset, body is longer than 150chars" do
    changeset =
      Article.changeset(
        %Article{},
        Map.put(@valid_attrs, :body, String.duplicate("a", 155))
      )

    refute changeset.valid?
  end

  test "changeset, published_date is empty" do
    changeset =
      Article.changeset(
        %Article{},
        Map.put(@valid_attrs, :published_date, "")
      )

    refute changeset.valid?
  end
end
