defmodule RedBlackTree do
  @moduledoc """
    Module for creating and managing red-black trees.
    Tree nodes have keys (a number that defines the relation between nodes) and data (anything you want).

    A red-black tree is a approximately balanced binary tree that satisfies the following red-black properties:
    1. Every node is either red or black.
    2. The root is black.   * We relax this rule as per to make deletion simpler
    3. Every leaf (NIL) is black.
    4. If a node is red, then both its children are black.
    5. For each node, all simple paths from the node to descendant leaves contain the
      same number of black nodes.

    Using the implementantion of insert from the article
    "Red-black trees in a functional setting" by Chris Okasaki
    Using the delete implementation from the article
    "FUNCTIONAL PEARL Deletion: The curse of the red-black tree" by Kimball Germane and Matthew Might
  """
  alias RedBlackTree, as: RBNode
  defstruct key: nil, left: nil, right: nil, data: nil, color: nil

  @doc """
  Creates a tree node.

  Returns `${key: nil, left: nil, right: nil, data: nil, color: nil}`.

  ## Examples

      iex> RedBlackTree.create()
      ${key: nil, left: nil, right: nil, data: nil, color: nil}

  """
  def create() do
    %RBNode{}
  end

  @doc """
  Creates a tree node.

  Returns `${key: nil, left: nil, right: nil, data: nil, color: nil}`.

  ## Examples

      iex> RedBlackTree.create(1, ${x: "my data"})
      ${key: 1, left: nil, right: nil, data: ${x: "my data"}), color: nil}

  """
  def create(key, data) do
    %RBNode{key: key, data: data}
  end

  defp balance(
         _node_color = :black,
         left_node = %RBNode{color: :red, left: %RBNode{color: :red}},
         actual_node,
         right_node
       ) do
    %RBNode{
      color: :red,
      left: %{left_node.left | color: :black},
      key: left_node.key,
      data: left_node.data,
      right: %RBNode{
        color: :black,
        key: actual_node.key,
        data: actual_node.data,
        left: left_node.right,
        right: right_node
      }
    }
  end

  defp balance(
         _node_color = :black,
         left_node = %RBNode{color: :red, right: %RBNode{color: :red}},
         actual_node,
         right_node
       ) do
    %RBNode{
      color: :red,
      left: %RBNode{
        color: :black,
        key: left_node.key,
        data: left_node.data,
        left: left_node.left,
        right: left_node.right.left
      },
      key: left_node.right.key,
      data: left_node.right.data,
      right: %RBNode{
        color: :black,
        key: actual_node.key,
        data: actual_node.data,
        left: left_node.right.right,
        right: right_node
      }
    }
  end

  defp balance(
         _node_color = :black,
         left_node,
         actual_node,
         right_node = %RBNode{color: :red, left: %RBNode{color: :red}}
       ) do
    %RBNode{
      color: :red,
      left: %RBNode{
        color: :black,
        key: actual_node.key,
        data: actual_node.data,
        left: left_node,
        right: right_node.left.left
      },
      key: right_node.left.key,
      data: right_node.left.data,
      right: %RBNode{
        color: :black,
        key: right_node.key,
        data: right_node.data,
        left: right_node.left.right,
        right: right_node.right
      }
    }
  end

  defp balance(
         _node_color = :black,
         left_node,
         actual_node,
         right_node = %RBNode{color: :red, right: %RBNode{color: :red}}
       ) do
    %RBNode{
      color: :red,
      left: %RBNode{
        color: :black,
        key: actual_node.key,
        data: actual_node.data,
        left: left_node,
        right: right_node.left
      },
      key: right_node.key,
      data: right_node.data,
      right: %{right_node.right | color: :black}
    }
  end

  defp balance(
         _node_color = :blackblack,
         left_node,
         actual_node,
         right_node = %RBNode{color: :red, left: %RBNode{color: :red}}
       ) do
    %RBNode{
      color: :black,
      left: %RBNode{
        color: :black,
        key: actual_node.key,
        data: actual_node.data,
        left: left_node,
        right: right_node.left.left
      },
      key: right_node.left.key,
      data: right_node.left.data,
      right: %RBNode{
        color: :black,
        key: right_node.key,
        data: right_node.data,
        left: right_node.left.right,
        right: right_node.right
      }
    }
  end

  defp balance(
         _node_color = :blackblack,
         left_node = %RBNode{color: :red, right: %RBNode{color: :red}},
         actual_node,
         right_node
       ) do
    %RBNode{
      color: :black,
      left: %RBNode{
        color: :black,
        key: left_node.key,
        data: left_node.data,
        left: left_node.left,
        right: left_node.right.left
      },
      key: left_node.right.key,
      data: left_node.right.data,
      right: %RBNode{
        color: :black,
        key: actual_node.key,
        data: actual_node.data,
        left: left_node.right.right,
        right: right_node
      }
    }
  end

  defp balance(node_color, left_node, actual_node, right_node) do
    %RBNode{
      color: node_color,
      left: left_node,
      key: actual_node.key,
      data: actual_node.data,
      right: right_node
    }
  end

  @doc """
  Inserts a node in a tree.

  Returns `${key: Number, left: %RBNode{}, right: %RBNode{}, data: :data, color: :red | :black | :blackblack }`.

  ## Examples

      iex> RedBlackTree.create(%RBNode{})
      %RBNode{}

  """
  def insert(new_node = %RBNode{}) do
    blacken(insert_rec(nil, new_node))
  end

  @doc """
  Inserts a node in a tree.

  Returns `${key: Number, left: %RBNode{}, right: %RBNode{}, data: :data, color: :red | :black | :blackblack }`.

  ## Examples

      iex> RedBlackTree.create(nil, %RBNode{})
      %RBNode{}

  """
  def insert(nil, new_node = %RBNode{}) do
    blacken(insert_rec(nil, new_node))
  end

  @doc """
  Inserts a given `new_node` in a `tree_root_node` tree.

  Returns `${key: Number, left: %RBNode{}, right: %RBNode{}, data: :data, color: :red | :black | :blackblack }`.

  ## Examples

      iex> RedBlackTree.create(%RBNode{}, %RBNode{})
      %RBNode{}

  """
  def insert(tree_root_node = %RBNode{}, new_node = %RBNode{}) do
    blacken(insert_rec(tree_root_node, new_node))
  end

  defp blacken(node = %RBNode{color: :red, left: %RBNode{color: :red}}) do
    %{node | color: :black}
  end

  defp blacken(node = %RBNode{color: :red, right: %RBNode{color: :red}}) do
    %{node | color: :black}
  end

  defp blacken(node = %RBNode{}) do
    node
  end

  defp insert_rec(_actual_tree_node = nil, new_node = %RBNode{}) do
    %{new_node | color: :red}
  end

  defp insert_rec(actual_tree_node = %RBNode{}, new_node = %RBNode{}) do
    cond do
      actual_tree_node.key > new_node.key ->
        balance(
          actual_tree_node.color,
          insert_rec(actual_tree_node.left, new_node),
          actual_tree_node,
          actual_tree_node.right
        )

      actual_tree_node.key == new_node.key ->
        actual_tree_node

      actual_tree_node.key < new_node.key ->
        balance(
          actual_tree_node.color,
          actual_tree_node.left,
          actual_tree_node,
          insert_rec(actual_tree_node.right, new_node)
        )
    end
  end

  @doc """
  deletes a node that has the given `key` in a `tree_root_node` tree.

  Returns `${key: Number, left: %RBNode{}, right: %RBNode{}, data: :data, color: :red | :black | :blackblack }`.

  ## Examples

      iex> RedBlackTree.delete(%RBNode{}, %RBNode{})
      %RBNode{}

  """
  def delete(tree_root_node = %RBNode{}, delete_key) do
    result = delete_rec(redden(tree_root_node), delete_key)
    result
  end

  defp redden(
         node = %RBNode{
           color: :black,
           left: %RBNode{color: :black},
           right: %RBNode{color: :black}
         }
       ) do
    %{node | color: :red}
  end

  defp redden(node = %RBNode{}) do
    node
  end

  defp delete_rec(actual_tree_node = %RBNode{color: :red, left: nil, right: nil}, delete_key) do
    if actual_tree_node.key == delete_key do
      nil
    else
      actual_tree_node
    end
  end

  defp delete_rec(actual_tree_node = %RBNode{color: :black, left: nil, right: nil}, delete_key) do
    if actual_tree_node.key == delete_key do
      :emptyempty
    else
      actual_tree_node
    end
  end

  defp delete_rec(
         actual_tree_node = %RBNode{
           color: :black,
           left: %RBNode{
             color: :red,
             left: nil,
             right: nil
           },
           right: nil
         },
         delete_key
       ) do
    cond do
      actual_tree_node.key > delete_key ->
        %{
          actual_tree_node
          | color: :black,
            left: delete_rec(actual_tree_node.left, delete_key),
            right: nil
        }

      actual_tree_node.key == delete_key ->
        %{actual_tree_node.left | color: :black, left: nil, right: nil}

      actual_tree_node.key < delete_key ->
        actual_tree_node
    end
  end

  defp delete_rec(actual_tree_node = %RBNode{}, delete_key) do
    cond do
      actual_tree_node.key < delete_key ->
        rotate(
          actual_tree_node.color,
          actual_tree_node.left,
          %{actual_tree_node | left: nil, right: nil},
          delete_rec(actual_tree_node.right, delete_key)
        )

      actual_tree_node.key == delete_key ->
        {y, b} = min_del(actual_tree_node.right)

        rotate(
          actual_tree_node.color,
          actual_tree_node.left,
          y,
          b
        )

      actual_tree_node.key > delete_key ->
        rotate(
          actual_tree_node.color,
          delete_rec(actual_tree_node.left, delete_key),
          %{actual_tree_node | left: nil, right: nil},
          actual_tree_node.right
        )
    end
  end

  defp rotate(
         _color = :red,
         left_node = %RBNode{color: :blackblack},
         actual_node = %RBNode{},
         right_node = %RBNode{color: :black}
       ) do
    balance(
      :black,
      %{actual_node | color: :red, left: %{left_node | color: :black}, right: right_node.left},
      %{right_node | left: nil, right: nil},
      right_node.right
    )
  end

  defp rotate(
         _color = :red,
         _left_node = :emptyempty,
         actual_node = %RBNode{},
         right_node = %RBNode{color: :black}
       ) do
    balance(
      :black,
      %{actual_node | color: :red, left: nil, right: right_node.left},
      %{right_node | left: nil, right: nil},
      right_node.right
    )
  end

  defp rotate(
         _color = :red,
         left_node = %RBNode{color: :black},
         actual_node = %RBNode{},
         right_node = %RBNode{color: :blackblack}
       ) do
    balance(:black, left_node.left, %{left_node | left: nil, right: nil}, %{
      actual_node
      | color: :red,
        left: left_node.right,
        right: %{right_node | color: :black}
    })
  end

  defp rotate(
         _color = :red,
         left_node = %RBNode{color: :black},
         actual_node = %RBNode{},
         _right_node = :emptyempty
       ) do
    balance(:black, left_node.left, %{left_node | left: nil, right: nil}, %{
      actual_node
      | color: :red,
        left: left_node.right,
        right: nil
    })
  end

  defp rotate(
         _color = :black,
         left_node = %RBNode{color: :blackblack},
         actual_node = %RBNode{},
         right_node = %RBNode{color: :black}
       ) do
    balance(
      :blackblack,
      %{actual_node | color: :red, left: %{left_node | color: :black}, right: right_node.left},
      %{right_node | left: nil, right: nil},
      right_node.right
    )
  end

  defp rotate(
         _color = :black,
         _left_node = :emptyempty,
         actual_node = %RBNode{},
         right_node = %RBNode{color: :black}
       ) do
    balance(
      :blackblack,
      %{actual_node | color: :red, left: nil, right: right_node.left},
      %{right_node | left: nil, right: nil},
      right_node.right
    )
  end

  defp rotate(
         _color = :black,
         left_node = %RBNode{color: :black},
         actual_node = %RBNode{},
         right_node = %RBNode{color: :blackblack}
       ) do
    balance(:blackblack, left_node.left, %{left_node | left: nil, right: nil}, %{
      actual_node
      | color: :red,
        left: left_node.right,
        right: %{right_node | color: :black}
    })
  end

  defp rotate(
         _color = :black,
         left_node = %RBNode{color: :black},
         actual_node = %RBNode{},
         _right_node = :emptyempty
       ) do
    balance(:blackblack, left_node.left, %{left_node | left: nil, right: nil}, %{
      actual_node
      | color: :red,
        left: left_node.right,
        right: nil
    })
  end

  defp rotate(
         _color = :black,
         left_node = %RBNode{color: :blackblack},
         actual_node = %RBNode{},
         right_node = %RBNode{color: :red, left: %RBNode{color: :black}}
       ) do
    %{
      right_node
      | color: :black,
        left:
          balance(
            :black,
            %{
              actual_node
              | color: :red,
                left: %{left_node | color: :black},
                right: right_node.left.left
            },
            %{right_node.left | left: nil, right: nil},
            right_node.left.left
          )
    }
  end

  defp rotate(
         _color = :black,
         _left_node = :emptyempty,
         actual_node = %RBNode{},
         right_node = %RBNode{color: :red, left: %RBNode{color: :black}}
       ) do
    %{
      right_node
      | color: :black,
        left:
          balance(
            :black,
            %{actual_node | color: :red, left: nil, right: right_node.left.left},
            %{right_node.left | left: nil, right: nil},
            right_node.left.right
          )
    }
  end

  defp rotate(
         _color = :black,
         left_node = %RBNode{color: :red, right: %RBNode{color: :black}},
         actual_node = %RBNode{},
         right_node = %RBNode{color: :blackblack}
       ) do
    %{
      left_node
      | color: :black,
        right:
          balance(:black, left_node.right.left, %{left_node.right | left: nil, right: nil}, %{
            actual_node
            | color: :red,
              left: left_node.right.right,
              right: %{right_node | color: :black}
          })
    }
  end

  defp rotate(
         _color = :black,
         left_node = %RBNode{color: :red, right: %RBNode{color: :black}},
         actual_node = %RBNode{},
         _right_node = :emptyempty
       ) do
    %{
      left_node
      | color: :black,
        right:
          balance(:black, left_node.right.left, %{left_node.right | left: nil, right: nil}, %{
            actual_node
            | color: :red,
              left: left_node.right.right,
              right: nil
          })
    }
  end

  defp rotate(color, left_node, actual_node, right_node) do
    %{actual_node | color: color, left: left_node, right: right_node}
  end

  defp min_del(actual_tree_node = %RBNode{color: :red, right: nil, left: nil}) do
    {actual_tree_node, nil}
  end

  defp min_del(actual_tree_node = %RBNode{color: :black, right: nil, left: nil}) do
    {actual_tree_node, :emptyempty}
  end

  defp min_del(
         actual_tree_node = %RBNode{
           color: :black,
           left: nil,
           right: %RBNode{color: :red, left: nil, right: nil}
         }
       ) do
    {actual_tree_node, %{actual_tree_node.right | color: :black}}
  end

  defp min_del(actual_tree_node = %RBNode{}) do
    {xl, al} = min_del(actual_tree_node.left)
    x = %{actual_tree_node | left: nil, right: nil}
    {xl, rotate(actual_tree_node.color, al, x, actual_tree_node.right)}
  end

  @doc """
  Searches for a node that has the given `key` in a `tree_root_node` tree.

  Returns `${key: Number, left: %RBNode{}, right: %RBNode{}, data: :data, color: :red | :black | :blackblack }`.

  ## Examples

      iex> RedBlackTree.search(%RBNode{}, nil)
      %RBNode{}

  """
  def search(_tree_root_node, _key = nil) do
    nil
  end

  @doc """
  Searches for a node that has the given `key` in a `tree_root_node` tree.

  Returns `${key: Number, left: %RBNode{}, right: %RBNode{}, data: :data, color: :red | :black | :blackblack }`.

  ## Examples

      iex> RedBlackTree.search(nil, 5)
      %RBNode{}

  """
  def search(_tree_root_node = nil, _key) do
    nil
  end

  @doc """
  Searches for a node that has the given `key` in a `tree_root_node` tree.

  Returns `${key: Number, left: %RBNode{}, right: %RBNode{}, data: :data, color: :red | :black | :blackblack }`.

  ## Examples

      iex> RedBlackTree.search(%RBNode{}, 5)
      %RBNode{}

  """
  def search(tree_root_node = %RBNode{}, key) do
    if tree_root_node.key == key do
      tree_root_node
    else
      if tree_root_node.key > key do
        search(tree_root_node.left, key)
      else
        search(tree_root_node.right, key)
      end
    end
  end
end
