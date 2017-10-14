defmodule Cookery.MaterializedPath do
  @moduledoc false

  import Ecto.Query, warn: false

  alias Ecto.Changeset
  alias Cookery.Repo

  def depth(item) do
    length(item.path)
  end

  def parent_id(item) do
    List.last(item.path)
  end

  def parent(%{path: []}), do: nil
  def parent(%{__struct__: struct} = item) do
    Repo.get(struct, parent_id(item))
  end

  def ancestor_ids(item) do
    item.path
  end

  def ancestors(%{__struct__: struct} = item) do
    from(q in struct, where: q.id in ^ancestor_ids(item))
    |> Repo.all()
  end

  def descendants(%{__struct__: struct} = item) do
    from(q in struct, where: fragment("? = ANY(path)", ^item.id))
    |> Repo.all()
  end

  def create(changeset, parent) do
    changeset
    |> Changeset.change(%{path: children_path(parent)})
    |> Repo.insert()
  end

  def delete(%{__struct__: struct, id: id}) do
    from(q in struct, where: q.id == ^id or fragment("? = ANY(path)", ^id))
    |> Repo.delete_all()
  end

  def update_parent(item, parent) do
    move_to_path(item, children_path(parent))
  end

  defp children_path(nil), do: []
  defp children_path(parent) do
    parent.path ++ [parent.id]
  end

  defp move_to_path(%{__struct__: struct} = item, new_path) do
    new_depth = depth(item) + 1
    from(q in struct,
      where: q.id == ^item.id or fragment("? = ANY(path)", ^item.id),
      update: [
        set: [
          path: fragment("? || path[? : array_length(path, 1)]", ^new_path, ^new_depth)
        ]
      ]
    )
    |> Repo.update_all([])
  end

  def arrange([]), do: []
  def arrange(items) do
    root_depth = items |> Enum.map(fn(item) -> depth(item) end) |> Enum.min
    root_items = items |> Enum.filter(fn(item) -> depth(item) == root_depth end)

    root_items |> Enum.map(fn(item) -> item_with_ancestors(item, items) end)
  end

  defp item_with_ancestors(parent, items) do
    {
      parent,
      items
      |> Enum.filter(fn(item) -> parent_id(item) == parent.id end)
      |> Enum.map(fn(item) -> item_with_ancestors(item, items) end)
    }
  end
end
