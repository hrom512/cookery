# Script for populating the database. You can run it as:
# mix run priv/repo/seeds.exs

alias Cookery.Data.Accounts
alias Cookery.Data.Recipes

{:ok, admin} = Accounts.create_user(%{name: "Admin", login: "admin", password: "123456"})
{:ok, vasia} = Accounts.create_user(%{name: "Вася Пупкин", login: "vasia", password: "123456"})
{:ok, ivan} = Accounts.create_user(%{name: "Иван Петров", login: "ivan", password: "123456"})

Accounts.update_user(vasia, %{
  avatar: %Plug.Upload{
    content_type: "image/jpeg",
    filename: "vasia.jpg",
    path: Path.join([Application.app_dir(:cookery, "priv"), "repo", "seeds", "avatars", "vasia.jpg"])
  }
})
Accounts.update_user(ivan, %{
  avatar: %Plug.Upload{
    content_type: "image/jpeg",
    filename: "ivan.jpg",
    path: Path.join([Application.app_dir(:cookery, "priv"), "repo", "seeds", "avatars", "ivan.jpg"])
  }
})

Recipes.create_recipe(vasia, %{
  "title" => "Бутерброды с семгой",
  "description" => "Пальчики оближешь"
})
Recipes.create_recipe(vasia, %{
  "title" => "Баклажаны по-китайски",
  "description" => "Запеченые баклажаны под острым соусом"
})
Recipes.create_recipe(vasia, %{
  "title" => "Оджахури по-грузински",
  "description" => "Мясо, овощи и арматные травы в мультварке"
})
Recipes.create_recipe(ivan, %{
  "title" => "Яичница с помидором",
  "description" => "Когда в холодильнике пусто"
})
