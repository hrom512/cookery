defmodule CookeryAdmin.GettextHelpers do
  @moduledoc false

  import CookeryAdmin.Gettext

  def gettext_yes_no(true), do: dgettext("admin", "Yes")
  def gettext_yes_no(false), do: dgettext("admin", "No")
end
