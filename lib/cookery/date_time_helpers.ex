defmodule Cookery.DateTimeHelpers do
  @moduledoc false

  use Timex

  def format_datetime(datetime, timezone, strftime_format \\ "%F %T") do
    datetime
    |> Timezone.convert(timezone)
    |> Timex.format!(strftime_format, :strftime)
  end
end
