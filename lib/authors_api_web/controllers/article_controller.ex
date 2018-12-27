defmodule AuthorsApiWeb.ArticleController do
  use AuthorsApiWeb, :controller
  import Ecto.Query, only: [from: 2]

  alias AuthorsApi.Article
  alias AuthorsApi.Repo

  action_fallback AuthorsApiWeb.FallbackController

  def index(conn, _params) do
    author_id = conn.assigns.current_author.id
    query = from a in Article, where: a.owner_id == ^author_id
    articles = Repo.all(query)
    render(conn, "index.json", articles: articles)
  end

  def create(conn, %{"article" => article_params}) do
    changeset =
      Article.changeset(%Article{owner_id: conn.assigns.current_author.id}, article_params)

    with {:ok, %Article{} = article} <- Repo.insert(changeset) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.article_path(conn, :show, article))
      |> render("show.json", article: article)
    end
  end

  def show(conn, %{"id" => id}) do
    article = Repo.get!(Article, id)
    render(conn, "show.json", article: article)
  end

  def delete(conn, %{"id" => id}) do
    article = Repo.get!(Article, id)

    with {:ok, %Article{}} <- Repo.delete(article) do
      send_resp(conn, :no_content, "")
    end
  end
end
