defmodule Github do
  alias Github.Repos.Get, as: RepoGet
  alias Github.Users.Create, as: UserCreate
  alias Github.Users.Get, as: UserGet
  alias Github.Users.Index, as: UserIndex

  defdelegate get_repo_by_username(params), to: RepoGet, as: :repos
  defdelegate create_user(params), to: UserCreate, as: :call
  defdelegate get_user_by_id(id), to: UserGet, as: :by_id
  defdelegate get_users(), to: UserIndex, as: :call
end
