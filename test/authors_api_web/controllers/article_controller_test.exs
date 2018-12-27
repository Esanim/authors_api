defmodule AuthorsApiWeb.ArticleControllerTest do
  use AuthorsApiWeb.ConnCase

  alias AuthorsApi.Article
  alias AuthorsApi.{Repo, Author, Session}

  @create_attrs_1 %{
    body: "some body",
    description: "some description",
    published_date: "2010-04-17T14:00:00Z",
    title: "some title"
  }

  @create_attrs_2 %{
    body: "another body",
    description: "another description",
    published_date: "2010-04-17T14:00:00Z",
    title: "another title"
  }

  @author1_valid_attrs %{first_name: "James", last_name: "Bagzynski", age: 18, owner_id: 1}
  @author2_valid_attrs %{first_name: "Amanda", last_name: "Hollow", age: 22, owner_id: 2}

  setup %{conn: conn} do
    author = create_author(@author1_valid_attrs)
    session = create_session(author)

    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "Token token=\"#{session.token}\"")

    {:ok, conn: conn, current_author: author}
  end

  def create_author(author_params) do
    Author.changeset(%Author{}, author_params) |> Repo.insert!()
  end

  def create_session(author) do
    Session.registration_changeset(%Session{author_id: author.id}, %{}) |> Repo.insert!()
  end

  def create_article(%{description: _description, owner_id: owner_id} = options) do
    Article.changeset(%Article{owner_id: owner_id}, options) |> Repo.insert!()
  end

  test "lists all entries on index", %{conn: conn, current_author: current_author} do
    create_article(Map.merge(@create_attrs_1, %{owner_id: current_author.id}))

    another_author = create_author(@author2_valid_attrs)
    create_article(Map.merge(@create_attrs_2, %{owner_id: another_author.id}))

    conn = get(conn, Routes.article_path(conn, :index))

    assert Enum.count(json_response(conn, 200)["data"]) == 1
    assert %{"description" => "some description"} = hd(json_response(conn, 200)["data"])
  end

  test "creates and renders resource when data is valid", %{
    conn: conn,
    current_author: current_author
  } do
    conn = post(conn, Routes.article_path(conn, :create), article: @create_attrs_1)
    assert json_response(conn, 201)["data"]["id"]
    article = Repo.get_by(Article, @create_attrs_1)
    assert article
    assert article.owner_id == current_author.id
  end

  test "ignores parameter owner_id and always assigns current_author as entry's owner", %{
    conn: conn,
    current_author: current_author
  } do
    other_author = create_author(@author2_valid_attrs)
    malicious_attrs = Map.merge(@create_attrs_1, %{owner_id: other_author.id})
    conn = post conn, Routes.article_path(conn, :create), article: malicious_attrs
    assert json_response(conn, 201)["data"]["id"]
    article = Repo.get_by(Article, @create_attrs_1)
    assert article
    assert article.owner_id == current_author.id
  end

  test "deletes chosen article", %{conn: conn} do
    conn = post(conn, Routes.article_path(conn, :create), article: @create_attrs_1)
    assert json_response(conn, 201)["data"]["id"]
    article = Repo.get_by(Article, @create_attrs_1)
    conn = delete(conn, Routes.article_path(conn, :delete, article))
    assert response(conn, 204)

    assert_error_sent 404, fn ->
      get(conn, Routes.article_path(conn, :show, article))
    end
  end

end
