defmodule CookeryAdmin do
  def controller do
    quote do
      use Phoenix.Controller, namespace: CookeryAdmin
      import Plug.Conn
      import CookeryAdmin.Router.Helpers
      import CookeryAdmin.Gettext

      # access to the current user
      import CookeryWeb.Loaders
      plug :load_current_user
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "lib/cookery_admin/templates",
                        namespace: CookeryAdmin

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import CookeryAdmin.Router.Helpers
      import CookeryAdmin.ErrorHelpers
      import CookeryAdmin.Gettext
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import CookeryAdmin.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
