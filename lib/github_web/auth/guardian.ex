defmodule GithubWeb.Auth.Guardian do
  use Guardian, otp_app: :github

  alias Github.{User, Error}
  alias Github.Users.Get, as: UserGet

  def subject_for_token(%User{id: id}, _claims) do
    {:ok, id}
  end

  def resource_from_claims(%{"sub" => id}) do
    case UserGet.by_id(id) do
      nil -> Error.build_user_not_found_error()
      user -> {:ok, user}
    end
  end

  def resource_from_claims(_), do: {:error, :unhandled_resource_type}

  def authenticate(%{"id" => user_id, "password" => password}) do
    with {:ok, %User{password_hash: hash} = user} <- UserGet.by_id(user_id),
         true <- Pbkdf2.verify_pass(password, hash),
         {:ok, token, _claims} <- encode_and_sign(user, %{}, ttl: {15, :seconds}) do
      {:ok, token}
    else
      false -> {:error, Error.build(:unauthorized, "Please verify your credentials")}
      error -> error
    end
  end

  def authenticate(_), do: {:error, Error.build(:bad_request, "Invalid or missing params")}

  def refresh_token(token, _claims) do
    # params = verify_claims(claims, %{})

    {:ok, _old_stuff, {token, claims}} = refresh(token, ttl: {15, :seconds})

    {:ok, %{token: token, claims: claims}}
  end
end
