defmodule CookeryAdmin.FormHelpers do
  @moduledoc false

  use Phoenix.HTML

  @doc """
  Form helpers for fields with label, input, error message.
  """
  def form_field(form, changeset, field, title) do
    form_field(form, changeset, field, title, &text_input/3)
  end
  def form_field_textarea(form, changeset, field, title) do
    form_field(form, changeset, field, title, &textarea/3)
  end
  def form_field_password(form, changeset, field, title) do
    form_field(form, changeset, field, title, &password_input/3)
  end
  def form_field_file(form, changeset, field, title) do
    form_field(form, changeset, field, title, &file_input/3)
  end
  def form_field_select(form, changeset, field, values_list, title) do
    form_field(
      form, changeset, field, title,
      &(select(&1, &2, values_list, &3))
    )
  end
  def form_field_multiple_select(form, changeset, field, title, values_list) do
    html_options = [style: "height: 300px;"]
    form_field(
      form, changeset, field, title,
      &(multiple_select(&1, &2, values_list, Keyword.merge(&3, html_options)))
    )
  end

  defp form_field(form, changeset, field, title, field_type) do
    content_tag :div, class: "form-group #{error_class(changeset, field)}" do
      [
        label(form, field, title),
        field_type.(form, field, class: "form-control"),
        error_tag(form, field),
      ]
    end
  end

  defp error_class(changeset, field) do
    if changeset.action && changeset.errors[field], do: "has-error"
  end

  defp error_tag(form, field) do
    Enum.map(Keyword.get_values(form.errors, field), fn (error) ->
      content_tag :span, translate_error(error), class: "help-block"
    end)
  end

  defp translate_error({msg, opts}) do
    if count = opts[:count] do
      Gettext.dngettext(CookeryAdmin.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(CookeryAdmin.Gettext, "errors", msg, opts)
    end
  end
end
