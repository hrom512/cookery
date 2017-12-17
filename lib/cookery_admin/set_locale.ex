defmodule CookeryAdmin.SetLocale do
  @moduledoc false

  import Plug.Conn

  @default_locale "en"
  @gettext_backend CookeryAdmin.Gettext
  @params_key "locale"
  @cookies_key "locale"

  def init(opts), do: opts

  def call(conn, _opts) do
    locale =
      get_locale_from_params(conn)
      || get_locale_from_cookies(conn)
      || @default_locale

    set_gettext_locale(locale)

    conn
    |> set_locale_to_cookies(locale)
  end

  defp get_locale_from_params(conn) do
    locale = conn.params[@params_key]
    if is_locale?(locale), do: locale, else: nil
  end

  defp get_locale_from_cookies(conn) do
    locale = conn.cookies[@cookies_key]
    if is_locale?(locale), do: locale, else: nil
  end

  defp is_locale?(nil), do: false
  defp is_locale?(locale), do: Enum.member?(supported_locales(), locale)

  defp supported_locales, do: Gettext.known_locales(@gettext_backend)

  defp set_gettext_locale(locale) do
    Gettext.put_locale(@gettext_backend, locale)
  end

  defp set_locale_to_cookies(conn, locale) do
    conn
    |> put_resp_cookie(@cookies_key, locale)
  end
end
