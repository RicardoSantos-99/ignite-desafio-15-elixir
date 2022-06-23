defmodule GithubWeb.FallbackController do
  use GithubWeb, :controller

  alias Github.Error
  alias GithubWeb.ErrorView

  def call(conn, {:error, %Error{status: status, result: result}}) do
    conn
    |> put_status(status)
    |> put_view(ErrorView)
    |> render("error.json", result: result)
  end
end
