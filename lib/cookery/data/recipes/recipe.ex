defmodule Cookery.Data.Recipes.Recipe do
  use Ecto.Schema
  import Ecto.Changeset
  alias Cookery.Data.Recipes.Recipe


  schema "recipes" do
    field :description, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(%Recipe{} = recipe, attrs) do
    recipe
    |> cast(attrs, [:title, :description])
    |> validate_required([:title])
  end
end
