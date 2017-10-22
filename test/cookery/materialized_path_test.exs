defmodule Cookery.MaterializedPathTest do
  use Cookery.DataCase

  import Cookery.MaterializedPath

  alias Cookery.Data.Recipes.Category

  def create_category(attrs, parent \\ nil) do
    %Category{}
    |> Category.changeset(attrs)
    |> create(parent)
  end

  def reload_category(category) do
    Repo.get(Category, category.id)
  end

  setup do
    {:ok, root} = create_category(%{name: "Root"})
    {:ok, children} = create_category(%{name: "Children"}, root)
    {:ok, sub_children} = create_category(%{name: "Children"}, children)
    {:ok, root: root, children: children, sub_children: sub_children}
  end

  test "depth/1", %{root: root, children: children, sub_children: sub_children} do
    assert depth(root) === 0
    assert depth(children) === 1
    assert depth(sub_children) === 2
  end

  test "parent_id/1", %{root: root, children: children, sub_children: sub_children} do
    assert parent_id(root) === nil
    assert parent_id(children) === root.id
    assert parent_id(sub_children) === children.id
  end

  test "parent/1", %{root: root, children: children, sub_children: sub_children} do
    assert parent(root) === nil
    assert parent(children) === root
    assert parent(sub_children) === children
  end

  test "ancestor_ids/1", %{root: root, children: children, sub_children: sub_children} do
    assert ancestor_ids(root) === []
    assert ancestor_ids(children) === [root.id]
    assert ancestor_ids(sub_children) === [root.id, children.id]
  end

  test "ancestors/1", %{root: root, children: children, sub_children: sub_children} do
    assert ancestors(root) === []
    assert ancestors(children) === [root]
    assert ancestors(sub_children) === [root, children]
  end

  test "descendants/1", %{root: root, children: children, sub_children: sub_children} do
    assert descendants(root) === [children, sub_children]
    assert descendants(children) === [sub_children]
    assert descendants(sub_children) === []
  end

  test "create/2", %{root: root, children: children, sub_children: sub_children} do
    assert root.path === []
    assert children.path === [root.id]
    assert sub_children.path === [root.id, children.id]
  end

  test "delete/1", %{root: root, children: children, sub_children: sub_children} do
    delete(root)

    assert Repo.get(Category, root.id) === nil
    assert Repo.get(Category, children.id) === nil
    assert Repo.get(Category, sub_children.id) === nil
  end

  test "update_parent/2", %{root: root, children: children, sub_children: sub_children} do
    update_parent(children, nil)
    children = reload_category(children)
    sub_children = reload_category(sub_children)

    assert children.path === []
    assert sub_children.path === [children.id]

    update_parent(children, root)
    children = reload_category(children)
    sub_children = reload_category(sub_children)

    assert children.path === [root.id]
    assert sub_children.path === [root.id, children.id]
  end

  test "arrange/1", %{root: root, children: children, sub_children: sub_children} do
    full_tree = [
      {root, [
        {children, [
          {sub_children, []}
        ]}
      ]}
    ]

    assert arrange([root, sub_children, children]) === full_tree
    assert arrange([root]) === [{root, []}]
    assert arrange([root, sub_children]) === [{root, []}]
    assert arrange([]) === []
  end
end
