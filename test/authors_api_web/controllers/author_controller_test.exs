defmodule AuthorsApi.AuthorControllerTest do
  use AuthorsApiWeb.ConnCase

  alias AuthorsApi.Author
  alias AuthorsApi.Repo

  @valid_attrs %{first_name: "James", last_name: "Bagzynski", age: 18}
  @update_attrs %{first_name: "Mark", last_name: "Bagzynski", age: 18}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post(conn, Routes.author_path(conn, :create), author: @valid_attrs)
    body = json_response(conn, 201)
    assert body["data"]["id"]
    assert body["data"]["first_name"]
    assert body["data"]["last_name"]
    assert body["data"]["age"]
    refute body["data"]["pet_name"]
    assert Repo.get_by(Author, first_name: "James")
  end

  test "renders author when data is valid", %{conn: conn} do
    conn = post(conn, Routes.author_path(conn, :create), author: @valid_attrs)
    id = json_response(conn, 201)["data"]["id"]
    assert id
    author = Repo.get_by(Author, first_name: "James")
    conn = put(conn, Routes.author_path(conn, :update, author), author: @update_attrs)
    assert %{"id" => ^id} = json_response(conn, 200)["data"]

    # conn = get(conn, Routes.author_path(conn, :show, id))

    assert %{
             "id" => id,
             "first_name" => "Mark",
             "last_name" => "Bagzynski",
             "age" => 18
           } = json_response(conn, 200)["data"]
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post(conn, Routes.author_path(conn, :create), author: @invalid_attrs)
    assert json_response(conn, 422)["errors"] != %{}
  end
end
