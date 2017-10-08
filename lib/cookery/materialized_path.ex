defmodule Cookery.MaterializedPath do
  import Ecto.Query, warn: false
  alias Cookery.Repo

  def depth(item) do
    length(item.path)
  end

  def parent_id(item) do
    List.last(item.path)
  end

  def parent(%{ path: [] }), do: nil
  def parent(item = %{ __struct__: struct }) do
    Repo.get(struct, parent_id(item))
  end

  def ancestor_ids(item) do
    item.path
  end

  def ancestors(item = %{ __struct__: struct }) do
    from(q in struct, where: q.id in ^ancestor_ids(item))
    |> Repo.all()
  end

  def descendants(item = %{ __struct__: struct }) do
    from(q in struct, where: fragment("? = ANY(path)", ^item.id))
    |> Repo.all()
  end

  def create(changeset, parent) do
    changeset
    |> Ecto.Changeset.change(%{ path: children_path(parent) })
    |> Repo.insert()
  end

  def delete(%{ __struct__: struct, id: id }) do
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

  defp move_to_path(item = %{ __struct__: struct}, new_path) do
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
    root_depth = Enum.map(items, fn(item) -> depth(item) end) |> Enum.min
    root_items = Enum.filter(items, fn(item) -> depth(item) == root_depth end)

    Enum.map(root_items, fn(item) -> item_with_ancestors(item, items) end)
  end

  defp item_with_ancestors(parent, items) do
    children = Enum.filter(items, fn(item) -> parent_id(item) == parent.id end)
    { parent, Enum.map(children, fn(item) -> item_with_ancestors(item, items) end) }
  end
end
