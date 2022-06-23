defmodule Github.Users.GetTest do
  use ExUnit.Case, async: true

  alias Github.Users.Get

  describe "get/1" do
    setup do
      bypass = Bypass.open()

      {:ok, bypass: bypass}
    end

    test "when there is valid username, returns repos", %{bypass: bypass} do
      username = "RicardoSantos-99"

      response = Get.user_repos(username)

      expect_response =
        {:ok,
         [
           %{
             description: nil,
             html_url:
               "https://github.com/RicardoSantos-99/algoritimos-e-estrutura-de-dados-linguagem-c",
             id: 340_495_881,
             name: "algoritimos-e-estrutura-de-dados-linguagem-c",
             stargazers_count: 0
           }
         ]}

      assert response == expect_response
    end

    test "when there is invalid username, returns an error", %{bypass: bypass} do
      username = "RicardoSantos-9"

      response = Get.user_repos(username)

      expect_response = {:error, %Github.Error{result: "User not found", status: :not_found}}

      assert response == expect_response
    end
  end
end
