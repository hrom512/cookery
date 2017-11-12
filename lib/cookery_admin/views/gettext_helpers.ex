defmodule CookeryAdmin.GettextHelpers do
  @moduledoc false

  import CookeryAdmin.Gettext

  def gettext_yes_no(true), do: gettext("Yes")
  def gettext_yes_no(false), do: gettext("No")
end
