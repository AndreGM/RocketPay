defmodule RocketpayWeb.AccountsControllerTest do
  use RocketpayWeb.ConnCase, async: true

  alias Rocketpay.{Account, User}

  describe "deposit/2" do
    setup %{conn: conn} do
      params = %{
        name: "Andre",
        password: "123456",
        nickname: "andre",
        email: "andre@banana.com",
        age: 40
      }
      {:ok, %User{account: %Account{id: account_id}}} = Rocketpay.create_user(params)

      conn = put_req_header(conn, "authorization", "Basic YmFuYW5hOm5hbmljYTEyMw==")

      {:ok, conn: conn, account_id: account_id}
    end

    test "when all params are valid, make deposit", %{conn: conn, account_id: account_id} do
      params = %{"value" => "50.00"}

      response = conn
      |> post(Routes.accounts_path(conn, :deposit, account_id, params))
      |> json_response(:ok)

      assert %{
        "account" => %{"balance" => "50.00", "id" => _id},
        "message" => "Balance changed Successfully"
      } = response
    end

    test "when thera are invalid params, returns a error", %{conn: conn, account_id: account_id} do
      params = %{"value" => "banana"}

      response = conn
      |> post(Routes.accounts_path(conn, :deposit, account_id, params))
      |> json_response(:bad_request)

      expected_response = %{"message" => "Invalid Operation"}
      assert response == expected_response
    end

  end
end
