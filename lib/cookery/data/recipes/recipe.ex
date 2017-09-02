defmodule Cookery.Data.Recipes.Recipe do
  use Cookery, :schema

  alias Cookery.Data.Recipes.Recipe
  alias Cookery.Data.Accounts.User

  schema "recipes" do
    field :description, :string
    field :title, :string
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(%Recipe{} = recipe, attrs) do
    recipe
    |> cast(attrs, [:user_id, :title, :description])
    |> validate_required([:user_id, :title])
  end
end
