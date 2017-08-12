defmodule Cookery.GuardianSerializer do
  @behaviour Guardian.Serializer

  alias Cookery.Data.Accounts
  alias Cookery.Data.Accounts.User

  def for_token(user = %User{}), do: { :ok, "user:#{user.id}" }
  def for_token(_), do: { :error, "Unknown resource type" }

  def from_token("user:" <> id), do: { :ok, Accounts.get_user!(id) }
  def from_token(_), do: { :error, "Unknown resource type" }
end
