defmodule AuthorsApiWeb.ArticleController do
  use AuthorsApiWeb, :controller
  import Ecto.Query, only: [from: 2]

  alias AuthorsApi.Content
  alias AuthorsApi.Content.Article
  alias AuthorsApi.Repo

  action_fallback AuthorsApiWeb.FallbackController

  plug AuthorsApiWeb.Authentication
  plug :scrub_params, "article" when action in [:create, :update]

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
    article = Content.get_article!(id)
    render(conn, "show.json", article: article)
  end

  # def update(conn, %{"id" => id, "article" => article_params}) do
  #   article = Content.get_article!(id)

  #   with {:ok, %Article{} = article} <- Content.update_article(article, article_params) do
  #     render(conn, "show.json", article: article)
  #   end
  # end

  def delete(conn, %{"id" => id}) do
    article = Content.get_article!(id)

    with {:ok, %Article{}} <- Content.delete_article(article) do
      send_resp(conn, :no_content, "")
    end
  end
end
