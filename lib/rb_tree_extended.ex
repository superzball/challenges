defmodule RedBlackTreeExtended do
  def get_min_rbt(nil) do
    {nil, false}
  end

  def get_min_rbt(%RedBlackTree{} = node) do
    if is_nil(node.left) do
       {node, true}
    else
      get_min_rbt(node.left)
    end
  end

  def get_max_rbt(nil) do
    {nil, false}
  end

  def get_max_rbt(%RedBlackTree{} = node) do
    if is_nil(node.right) do
      {node, true}
    else
      get_max_rbt(node.right)
    end
  end

  def rbt_to_list(node, acc \\ [],sort \\ "asc")
  def rbt_to_list(nil, acc, _sort) do
    acc
  end
  def rbt_to_list(%RedBlackTree{} = node, acc, sort) do
    do_to_list(node, acc, sort) |> Enum.reverse
  end
  defp do_to_list(nil, acc, _sort) do
    acc
  end
  defp do_to_list(%RedBlackTree{data: nil} = node, acc, sort) when sort == "asc" do
    do_to_list(node.right, [node.key | do_to_list(node.left, acc, sort)], sort)
  end
  defp do_to_list(%RedBlackTree{data: nil} = node, acc, sort) when sort == "desc" do
    do_to_list(node.left, [node.key | do_to_list(node.right, acc, sort)], sort)
  end
  defp do_to_list(%RedBlackTree{} = node, acc, sort)  when sort == "asc" do
    do_to_list(node.right, [ node.data | do_to_list(node.left, acc, sort)], sort)
  end
  defp do_to_list(%RedBlackTree{} = node, acc, sort)  when sort == "desc" do
    do_to_list(node.left, [ node.data | do_to_list(node.right, acc, sort)], sort)
  end

  def insert(%RedBlackTree{} = tree_root_node ,%RedBlackTree{} = new_node) do
    RedBlackTree.insert(tree_root_node, new_node)
  end
  def insert(:emptyempty, new_node = %RedBlackTree{}) do
    RedBlackTree.insert(nil, new_node)
  end
  def insert(nil, new_node = %RedBlackTree{}) do
    RedBlackTree.insert(nil, new_node)
  end
end
