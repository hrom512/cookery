defmodule Cookery.Data.Recipes.Recipe do
  use Cookery, :schema

  alias Cookery.Data.Recipes.Recipe
  alias Cookery.Data.Recipes.Category
  alias Cookery.Data.Accounts.User

  schema "recipes" do
    field :description, :string
    field :title, :string
    belongs_to :user, User
    many_to_many :categories, Category,
      join_through: "recipes_categories",
      on_replace: :delete
    field :categories_ids, {:array, :integer}, virtual: true

    timestamps()
  end

  @doc false
  def changeset(%Recipe{} = recipe, attrs) do
    recipe
    |> cast(attrs, [:title, :description, :user_id, :categories_ids])
    |> validate_required([:title, :user_id])
  end
end
