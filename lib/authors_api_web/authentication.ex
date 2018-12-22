defmodule AuthorsApiWeb.Authentication do
  import Plug.Conn
  alias AuthorsApi.{Repo, Author, Session}
  import Ecto.Query, only: [from: 2]

  def init(options), do: options

  def call(conn, _opts) do
    case find_author(conn) do
      {:ok, author} -> assign(conn, :current_author, author)
      _otherwise -> auth_error!(conn)
    end
  end

  defp find_author(conn) do
    with auth_header = get_req_header(conn, "authorization"),
         {:ok, token} <- parse_token(auth_header),
         {:ok, session} <- find_session_by_token(token),
         do: find_author_by_session(session)
  end

  defp parse_token(["Token token=" <> token]) do
    {:ok, String.replace(token, "\"", "")}
  end

  defp parse_token(_non_token_header), do: :error

  defp find_session_by_token(token) do
    case Repo.one(from s in Session, where: s.token == ^token) do
      nil -> :error
      session -> {:ok, session}
    end
  end

  defp find_author_by_session(session) do
    case Repo.get(Author, session.author_id) do
      nil -> :error
      author -> {:ok, author}
    end
  end

  defp auth_error!(conn) do
    conn |> put_status(:unauthorized) |> halt()
  end
end
