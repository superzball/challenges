defmodule Challenges.MatchingEngine do
  @moduledoc false
  use GenServer

  defmodule Order do
    defstruct price: 0.0, volume: 0.0
  end

  defmodule OrderBook do
    defstruct tree_buy: %{}, tree_sell: %{}
  end

  defmodule OrderBookFromJson do
    @derive [Poison.Encoder]
    defstruct [:command, :price, :amount]
  end

  def start_link(_opts) do
    order_book = %OrderBook{
      tree_buy: nil,
      tree_sell: nil
    }

    GenServer.start_link(__MODULE__, order_book, name: __MODULE__)
  end

  @impl true
  def init(%OrderBook{} = order_book) do
    {:ok, order_book}
  end

  def create(server, name) do
    GenServer.cast(server, {:create, name})
  end

  def limit_order(command, price, amount) do
    {:ok, amount} = Decimal.cast(amount)
    order = %Order{price: price, volume: amount}
    GenServer.call(__MODULE__, {:limit_order, order, command})
  end

  @impl true
  def handle_call({:limit_order, %Order{} = order, command}, _from, %OrderBook{} = order_book)
      when command == "buy" and order.price > 0 and order.volume > 0 do
    {order_book} = buy_limit_order(order, order_book)
    {:reply, {:ok, print_order_book(order_book)}, order_book}
  end

  @impl true
  def handle_call({:limit_order, %Order{} = order, command}, _from, %OrderBook{} = order_book)
      when command == "sell" and order.price > 0 and order.volume > 0 do
    {order_book} = sell_limit_order(order, order_book)
    {:reply, {:ok, print_order_book(order_book)}, order_book}
  end

  def buy_limit_order(%Order{} = order, %OrderBook{} = order_book) do
    {min_sell_order, ok} = RedBlackTreeExtended.get_min_rbt(order_book.tree_sell)

    if ok && order.price >= min_sell_order.data.price do
      volume = Decimal.sub(order.volume, min_sell_order.data.volume)

      if Decimal.gt?(volume, 0) do
        order_book = %{
          order_book
          | tree_sell: RedBlackTree.delete(order_book.tree_sell, min_sell_order.data.price)
        }

        order = %{order | volume: volume}
        buy_limit_order(order, order_book)
      else
        abs_volume = Decimal.abs(volume)

        new_node = %RedBlackTree{
          key: min_sell_order.data.price,
          data: %Order{price: min_sell_order.data.price, volume: abs_volume}
        }

        order_book = %{
          order_book
          | tree_sell: RedBlackTree.delete(order_book.tree_sell, min_sell_order.data.price)
        }

        if Decimal.gt?(abs_volume, 0) do
          {%{order_book | tree_sell: RedBlackTreeExtended.insert(order_book.tree_sell, new_node)}}
        else
          {order_book}
        end
      end
    else
      new_node = %RedBlackTree{key: order.price, data: order}
      old_node = RedBlackTree.search(order_book.tree_buy, order.price)

      if is_nil(old_node) do
        {%{order_book | tree_buy: RedBlackTree.insert(order_book.tree_buy, new_node)}}
      else
        new_node = %{
          new_node
          | data: %{
              new_node.data
              | volume: Decimal.add(new_node.data.volume, old_node.data.volume)
            }
        }

        order_book = %{
          order_book
          | tree_buy: RedBlackTree.delete(order_book.tree_buy, order.price)
        }

        {%{order_book | tree_buy: RedBlackTreeExtended.insert(order_book.tree_buy, new_node)}}
      end
    end
  end

  def sell_limit_order(%Order{} = order, %OrderBook{} = order_book) do
    {max_buy_order, ok} = RedBlackTreeExtended.get_max_rbt(order_book.tree_buy)

    if ok && order.price <= max_buy_order.data.price do
      volume = Decimal.sub(order.volume, max_buy_order.data.volume)

      if Decimal.gt?(volume, 0) do
        order_book = %{
          order_book
          | tree_buy: RedBlackTree.delete(order_book.tree_buy, max_buy_order.data.price)
        }

        order = %{order | volume: volume}
        sell_limit_order(order, order_book)
      else
        abs_volume = Decimal.abs(volume)

        new_node = %RedBlackTree{
          key: max_buy_order.data.price,
          data: %Order{price: max_buy_order.data.price, volume: abs_volume}
        }

        order_book = %{
          order_book
          | tree_buy: RedBlackTree.delete(order_book.tree_buy, max_buy_order.data.price)
        }

        if Decimal.gt?(abs_volume, 0) do
          {%{order_book | tree_buy: RedBlackTreeExtended.insert(order_book.tree_buy, new_node)}}
        else
          {order_book}
        end
      end
    else
      new_node = %RedBlackTree{key: order.price, data: order}
      old_node = RedBlackTree.search(order_book.tree_sell, order.price)

      if is_nil(old_node) do
        {%{order_book | tree_sell: RedBlackTree.insert(order_book.tree_sell, new_node)}}
      else
        new_node = %{
          new_node
          | data: %{
              new_node.data
              | volume: Decimal.add(new_node.data.volume, old_node.data.volume)
            }
        }

        order_book = %{
          order_book
          | tree_sell: RedBlackTree.delete(order_book.tree_sell, order.price)
        }

        {%{order_book | tree_sell: RedBlackTreeExtended.insert(order_book.tree_sell, new_node)}}
      end
    end
  end

  def print_order_book(%OrderBook{} = order_book) do
    list_buy = RedBlackTreeExtended.rbt_to_list(order_book.tree_buy, [], "desc")
    list_sell = RedBlackTreeExtended.rbt_to_list(order_book.tree_sell)
    {Poison.encode!(%{buy: list_buy, sell: list_sell})}
    # %{buy: list_buy, sell: list_sell}
  end

  def import_order_from_json_file(filename) do
    {:ok, body} = File.read(filename)
    value = Poison.decode!(body, as: %{"orders" => [%OrderBookFromJson{}]})
    for val <- Map.get(value, "orders"), do: limit_order(val.command, val.price, val.amount)
  end
end
