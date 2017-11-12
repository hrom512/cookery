defmodule CookeryAdmin.UserView do
  use CookeryAdmin, :view

  def timezones_list do
    Timex.timezones
  end
end
