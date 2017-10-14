defmodule CookeryAdmin.Plug do
  @moduledoc false

  alias CookeryAdmin.Router

  def init(opts), do: opts
  def call(conn, opts) do
    Router.call(conn, opts)
  end
end
