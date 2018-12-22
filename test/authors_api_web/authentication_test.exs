defmodule AuthorsApiWeb.AuthenticationTest do
  use AuthorsApiWeb.ConnCase

  alias AuthorsApi.{Repo, Author, Session}
  alias AuthorsApiWeb.Authentication

  @opts Authentication.init([])

  def put_auth_token_in_header(conn, token) do
    conn
    |> put_req_header("authorization", "Token token=\"#{token}\"")
  end

  test "finds the author by token", %{conn: conn} do
    author = Repo.insert!(%Author{first_name: "James", last_name: "Bagzynski", age: 18})
    session = Repo.insert!(%Session{token: "123", author_id: author.id})

    conn = conn
    |> put_auth_token_in_header(session.token)
    |> Authentication.call(@opts)

    assert conn.assigns.current_author
  end

  test "invalid token", %{conn: conn} do
    conn = conn
    |> put_auth_token_in_header("foo")
    |> Authentication.call(@opts)

    assert conn.status == 401
    assert conn.halted
  end

  test "no token", %{conn: conn} do
    conn = Authentication.call(conn, @opts)
    assert conn.status == 401
    assert conn.halted
  end
end
