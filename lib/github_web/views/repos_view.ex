defmodule GithubWeb.ReposView do
  use GithubWeb, :view

  def render("repos.json", %{repos: repos}) do
    %{data: render_many(repos, __MODULE__, "repo.json")}
  end

  def render("repo.json", %{repos: repo}) do
    %{
      "id" => repo.id,
      "name" => repo.name,
      "description" => repo.description,
      "html_url" => repo.html_url,
      "stargazers_count" => repo.stargazers_count
    }
  end
end
