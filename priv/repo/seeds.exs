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

# Recipes
Recipes.create_recipe(%{
  "title" => "Бутерброды с семгой",
  "description" => "Пальчики оближешь"
}, vasia)
Recipes.create_recipe(%{
  "title" => "Баклажаны по-китайски",
  "description" => "Запеченые баклажаны под острым соусом"
}, vasia)
Recipes.create_recipe(%{
  "title" => "Оджахури по-грузински",
  "description" => "Мясо, овощи и арматные травы в мультварке"
}, vasia)
Recipes.create_recipe(%{
  "title" => "Яичница с помидором",
  "description" => "Когда в холодильнике пусто"
}, ivan)
