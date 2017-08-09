defmodule CookeryAdmin.Plug do
  def init(opts), do: opts
  def call(conn, opts) do
    CookeryAdmin.Router.call(conn, opts)
  end
end
