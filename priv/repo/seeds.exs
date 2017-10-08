# Script for populating the database. You can run it as:
# mix run priv/repo/seeds.exs

alias Cookery.Data.Accounts
alias Cookery.Data.Recipes

defmodule Seeds do
  def set_avatar(user, filename) do
    Accounts.update_user(user, %{
      avatar: %Plug.Upload{
        content_type: "image/jpeg",
        filename: filename,
        path: Path.join([Application.app_dir(:cookery, "priv"), "repo", "seeds", "avatars", filename])
      }
    })
  end

  def create_subcategories(parent, names) do
    Enum.map names, fn name ->
      Recipes.create_category(%{ "name" => name }, parent)
    end
  end
end

# Admin
{:ok, admin} = Accounts.create_admin(%{
  name: "Admin",
  login: "admin",
  password: "123456",
  is_admin: true
})

# Users
{:ok, vasia} = Accounts.create_user(%{
  name: "Вася Пупкин",
  login: "vasia",
  password: "123456",
  timezone: "Europe/London"
})
{:ok, ivan} = Accounts.create_user(%{
  name: "Иван Петров",
  login: "ivan",
  password: "123456",
  timezone: "Europe/Warsaw"
})

# Avatars
Seeds.set_avatar(vasia, "vasia.jpg")
Seeds.set_avatar(ivan, "ivan.jpg")

# Categories
{:ok, hot_dishes} = Recipes.create_category(%{name: "Горячие блюда"})
{:ok, soups} = Recipes.create_category(%{name: "Супы"})
{:ok, salads} = Recipes.create_category(%{name: "Салаты"})
Seeds.create_subcategories(hot_dishes, ["Каша", "Плов", "Запеканки"])
Seeds.create_subcategories(soups, ["Борщ", "Грибной суп", "Гороховый суп"])
Seeds.create_subcategories(salads, ["Салат из курицы", "Салат из помидоров", "Винегрет"])

# Recipes
{:ok, recipe1} = Recipes.create_recipe(%{
  "title" => "Бутерброды с семгой",
  "description" => "Пальчики оближешь"
}, vasia)
{:ok, recipe2} = Recipes.create_recipe(%{
  "title" => "Баклажаны по-китайски",
  "description" => "Запеченые баклажаны под острым соусом"
}, vasia)
{:ok, recipe3} = Recipes.create_recipe(%{
  "title" => "Оджахури по-грузински",
  "description" => "Мясо, овощи и арматные травы в мультварке"
}, vasia)
{:ok, recipe4} = Recipes.create_recipe(%{
  "title" => "Яичница с помидором",
  "description" => "Когда в холодильнике пусто"
}, ivan)

# Assign recipes with categories
Recipes.update_recipe_categories(recipe1, [hot_dishes])
Recipes.update_recipe_categories(recipe2, [hot_dishes])
Recipes.update_recipe_categories(recipe3, [hot_dishes])
Recipes.update_recipe_categories(recipe4, [hot_dishes])
