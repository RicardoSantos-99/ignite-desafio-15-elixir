defmodule Github.Repos.Get do
  use Tesla

  alias Tesla.Env
  alias Github.Error

  @request_headers [{"user-agent", "Tesla"}]

  plug Tesla.Middleware.Headers, @request_headers
  @base_url "https://api.github.com"
  plug Tesla.Middleware.JSON

  def repos(url \\ @base_url, username) do
    "#{url}/users/#{username}/repos?per_page=1"
    |> get()
    |> handle_get()
  end

  defp handle_get({:ok, %Env{status: 200, body: body}}) do
    {:ok, convert_body(body)}
  end

  defp handle_get({:ok, %Env{body: %{"message" => _message}}}) do
    {:error, Error.build_user_not_found_error()}
  end

  defp convert_body(body) do
    Enum.map(body, fn elem ->
      %{
        name: elem["name"],
        id: elem["id"],
        description: elem["description"],
        html_url: elem["html_url"],
        stargazers_count: elem["stargazers_count"]
      }
    end)
  end
end
