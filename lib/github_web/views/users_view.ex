defmodule GithubWeb.UsersView do
  use GithubWeb, :view

  alias Github.User

  def render("create.json", %{token: token, user: %User{} = user}) do
    %{
      token: token,
      id: user.id
    }
  end

  def render("sign_in.json", %{token: token}), do: %{token: token}

  def render("user.json", %{user: %User{} = user}), do: %{user: user}

  def render("list_users.json", %{users: users}) do
    %{data: render_many(users, __MODULE__, "one_user.json")}
  end

  def render("one_user.json", %{users: user}) do
    %{
      "id" => user.id
    }
  end
end
