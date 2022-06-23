defmodule GithubWeb.RepoController do
  use GithubWeb, :controller

  alias GithubWeb.ReposView

  def index(conn, %{"username" => username}) do
    case Github.get_repo_by_username(username) do
      {:ok, repos} ->
        conn
        |> put_status(:ok)
        |> put_view(ReposView)
        |> render("repos.json", repos: repos)

      {:error, message} ->
        conn
        |> put_status(:bad_request)
        |> put_view(GithubWeb.ErrorView)
        |> render("error.json", message: message)
    end
  end
end
