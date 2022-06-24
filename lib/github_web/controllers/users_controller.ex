defmodule GithubWeb.UsersController do
  use GithubWeb, :controller

  alias Github.User
  alias GithubWeb.{Auth.Guardian, FallbackController}

  action_fallback FallbackController

  def create(conn, params) do
    with {:ok, %User{} = user} <- Github.create_user(params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user, %{}, ttl: {15, :seconds}) do
      conn
      |> put_status(:created)
      |> render("create.json", token: token, user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, %User{} = user} <- Github.get_user_by_id(id) do
      conn
      |> put_status(:ok)
      |> render("user.json", user: user)
    end
  end

  def sign_in(conn, params) do
    with {:ok, token} <- Guardian.authenticate(params) do
      conn
      |> put_status(:ok)
      |> render("sign_in.json", token: token)
    end
  end

  def index(conn, _params) do
    %Plug.Conn{
      private: %{
        guardian_default_token: token,
        guardian_default_claims: claims
      }
    } = conn

    with {:ok, users} <- Github.get_users(),
         {:ok, %{token: token, claims: _claims}} =
           GithubWeb.Auth.Guardian.refresh_token(token, claims) do
      conn
      |> put_status(:ok)
      |> render("list_users.json", users: users, token: token)
    end
  end
end

# %Plug.Conn{
#   adapter: {Plug.Cowboy.Conn, :...},
#   assigns: %{},
#   body_params: %{},
#   cookies: %{},
#   halted: false,
#   host: "localhost",
#   method: "GET",
#   owner: #PID<0.628.0>,
#   params: %{},
#   path_info: ["api", "users"],
#   path_params: %{},
#   port: 4000,
#   private: %{
#     GithubWeb.Router => {[], %{}},
#     :before_send => [#Function<0.23023616/1 in Plug.Telemetry.call/2>],
#     :guardian_default_claims => %{
#       "aud" => "github",
#       "exp" => 1656030182,
#       "iat" => 1656028382,
#       "iss" => "github",
#       "jti" => "e22cbf94-ae5b-4aa8-907d-355c0e494930",
#       "nbf" => 1656028381,
#       "sub" => "62db0e34-abe5-4743-850c-c26b8f61f904",
#       "typ" => "access"
#     },
#     :guardian_default_resource => {:ok,
#      %Github.User{
#        __meta__: #Ecto.Schema.Metadata<:loaded, "users">,
#        id: "62db0e34-abe5-4743-850c-c26b8f61f904",
#        inserted_at: ~N[2022-06-22 17:50:57],
#        password: nil,
#        password_hash: "$pbkdf2-sha512$160000$TE/M6Ch5qq27zK1gDvQx.g$CvzPfYHqFHWab3Pza9ICytBasAj3bp36eSAxvkmDOLpaUMjiPFXJ15lVHiu6e5wXsjkznAAHkZOQGP38l2EubA",
#        updated_at: ~N[2022-06-22 17:50:57]
#      }},
#     :guardian_default_token => "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJnaXRodWIiLCJleHAiOjE2NTYwMzAxODIsImlhdCI6MTY1NjAyODM4MiwiaXNzIjoiZ2l0aHViIiwianRpIjoiZTIyY2JmOTQtYWU1Yi00YWE4LTkwN2QtMzU1YzBlNDk0OTMwIiwibmJmIjoxNjU2MDI4MzgxLCJzdWIiOiI2MmRiMGUzNC1hYmU1LTQ3NDMtODUwYy1jMjZiOGY2MWY5MDQiLCJ0eXAiOiJhY2Nlc3MifQ.JWOOAI0xBju0VLZdl-fB2HOugQZPWpC5FPwZJWLOhNCUZ_SaL8T5uPfmwGZZA8L7GRmmsQwrZnFUkt3DrVqs9A",
#     :guardian_error_handler => GithubWeb.Auth.ErrorHandler,
#     :guardian_module => GithubWeb.Auth.Guardian,
#     :phoenix_action => :index,
#     :phoenix_controller => GithubWeb.UsersController,
#     :phoenix_endpoint => GithubWeb.Endpoint,
#     :phoenix_format => "json",
#     :phoenix_layout => {GithubWeb.LayoutView, :app},
#     :phoenix_request_logger => {"request_logger", "request_logger"},
#     :phoenix_router => GithubWeb.Router,
#     :phoenix_view => GithubWeb.UsersView,
#     :plug_session_fetch => #Function<1.77458138/1 in Plug.Session.fetch_session/1>
#   },
#   query_params: %{},
#   query_string: "",
#   remote_ip: {127, 0, 0, 1},
#   req_cookies: %{},
#   req_headers: [
#     {"accept", "*/*"},
#     {"authorization",
#      "Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJnaXRodWIiLCJleHAiOjE2NTYwMzAxODIsImlhdCI6MTY1NjAyODM4MiwiaXNzIjoiZ2l0aHViIiwianRpIjoiZTIyY2JmOTQtYWU1Yi00YWE4LTkwN2QtMzU1YzBlNDk0OTMwIiwibmJmIjoxNjU2MDI4MzgxLCJzdWIiOiI2MmRiMGUzNC1hYmU1LTQ3NDMtODUwYy1jMjZiOGY2MWY5MDQiLCJ0eXAiOiJhY2Nlc3MifQ.JWOOAI0xBju0VLZdl-fB2HOugQZPWpC5FPwZJWLOhNCUZ_SaL8T5uPfmwGZZA8L7GRmmsQwrZnFUkt3DrVqs9A"},
#     {"host", "localhost:4000"},
#     {"user-agent", "insomnia/2022.4.2"}
#   ],
#   request_path: "/api/users",
#   resp_body: nil,
#   resp_cookies: %{},
#   resp_headers: [
#     {"cache-control", "max-age=0, private, must-revalidate"},
#     {"x-request-id", "FvtlC-dEhM-KcOsAAAHJ"}
#   ],
#   scheme: :http,
#   script_name: [],
#   secret_key_base: :...,
#   state: :unset,
#   status: nil
# }
