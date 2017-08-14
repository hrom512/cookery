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

  def storage_dir(version, {file, scope}) do
    "priv/uploads/avatars/#{scope.id}"
  end

  def filename(version, _) do
    version
  end

  def make_url(user, version) do
    if user.avatar do
      "/uploads/avatars/#{user.id}/#{version}.png"
    else
      default_url(version, user)
    end
  end


  def default_url(version, _scope) do
    "/images/avatars/#{version}.png"
  end

  # Specify custom headers for s3 objects
  # Available options are [:cache_control, :content_disposition,
  #    :content_encoding, :content_length, :content_type,
  #    :expect, :expires, :storage_class, :website_redirect_location]
  #
  # def s3_object_headers(version, {file, scope}) do
  #   [content_type: Plug.MIME.path(file.file_name)]
  # end
end
