defmodule Rocketpay.Users.CreateTest do
  use Rocketpay.DataCase

  alias Rocketpay.User
  alias Rocketpay.Users.Create

  describe "call/1" do
    test "When all params are valid, return an user" do
      params = %{
        name: "Andre",
        password: "123456",
        nickname: "andre",
        email: "andre@banana.com",
        age: 40
      }

      {:ok, %User{id: user_id}} = Create.call(params)
      user = Repo.get(User, user_id)
      assert %User{name: "Andre", age: 40, id: ^user_id} = user
    end

    test "When all params are invalid, return an error" do
      params = %{
        name: "Andre",
        nickname: "andre",
        email: "andre@banana.com",
        age: 15
      }

      {:error, changeset} = Create.call(params)
      expected_response =  %{
        age: ["must be greater than or equal to 18"],
        password: ["can't be blank"]
      }
      # assert "banana" == errors_on(changeset)
      assert errors_on(changeset) == expected_response
    end


  end
end
