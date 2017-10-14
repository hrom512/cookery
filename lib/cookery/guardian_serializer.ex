defmodule Cookery.GuardianSerializer do
  @moduledoc false

  @behaviour Guardian.Serializer

  alias Cookery.Data.Accounts
  alias Cookery.Data.Accounts.User

  def for_token(%User{id: id}), do: {:ok, "user:#{id}"}
  def for_token(_), do: {:error, "Unknown resource type"}

  def from_token("user:" <> id), do: {:ok, Accounts.get_user!(id)}
  def from_token(_), do: {:error, "Unknown resource type"}
end
