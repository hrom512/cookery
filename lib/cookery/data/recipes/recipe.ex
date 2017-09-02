defmodule Cookery.Data.Recipes.Recipe do
  use Ecto.Schema
  import Ecto.Changeset

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
    |> cast(attrs, [:title, :description])
    |> validate_required([:title])
  end
end
