defmodule Cookery.Avatar do
  use Arc.Definition
  use Arc.Ecto.Definition

  @versions [:original, :thumb]

  def validate({file, _}) do
    ~w(.jpg .jpeg .gif .png)
    |> Enum.member?(Path.extname(file.file_name))
  end

  def transform(:thumb, _) do
    {:convert, "-strip -thumbnail 29x29^ -gravity center -extent 29x29 -format png", :png}
  end

  def storage_dir(_version, {_file, scope}) do
    "uploads/avatars/#{scope.id}"
  end

  def filename(version, _) do
    version
  end

  def make_url(user, version) do
    url({user.avatar, user}, version)
  end

  def default_url(version, _scope) do
    "/images/avatars/#{version}.png"
  end

  def s3_object_headers(_version, {file, _scope}) do
    [content_type: Plug.MIME.path(file.file_name)]
  end
end
