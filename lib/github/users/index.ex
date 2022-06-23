defmodule Github.Users.Index do
  alias Github.{User, Error, Repo}

  def call() do
    case Repo.all(User) do
      nil -> {:error, Error.build_user_not_found_error()}
      users -> {:ok, users}
    end
  end
end
