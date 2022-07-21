defmodule Challenges.MatchingEngineTest do
  use ExUnit.Case, async: false
  doctest Challenges.MatchingEngine

  alias Challenges.{
    MatchingEngine,
    MatchingEngine.OrderBook,
    MatchingEngine.Order,
  }

  describe "limit_order" do
    test "create buy limit order case new price" do
      ob = %OrderBook{
        tree_buy: nil,
        tree_sell: nil
      }

      order = %Order{price: 10.5,volume: Decimal.new(2)}
      {actual} = MatchingEngine.buy_limit_order(order, ob)
      assert order == actual.tree_buy.data
      assert order.price == actual.tree_buy.key
    end

    test "create sell limit order case new price" do
      ob = %OrderBook{
        tree_buy: nil,
        tree_sell: nil
      }

      order = %Order{price: 10.5,volume: Decimal.new(2)}
      {actual} = MatchingEngine.sell_limit_order(order, ob)
      assert order == actual.tree_sell.data
      assert order.price == actual.tree_sell.key
    end

    test "create buy limit order case same price" do
      order = %Order{price: 10.5,volume: Decimal.new(2)}
      ob = %OrderBook{
        tree_buy: RedBlackTree.insert(nil, %RedBlackTree{key: 10.5, data: order}),
        tree_sell: nil
      }

      expect = %Order{price: 10.5,volume: Decimal.new(4)}
      {actual} = MatchingEngine.buy_limit_order(order, ob)
      assert expect == actual.tree_buy.data
      assert expect.price == actual.tree_buy.key
    end


    test "create sell limit order case same price" do
      order = %Order{price: 10.5,volume: Decimal.new(2)}
      ob = %OrderBook{
        tree_buy: nil,
        tree_sell: RedBlackTree.insert(nil, %RedBlackTree{key: 10.5, data: order})
      }

      expect = %Order{price: 10.5,volume: Decimal.new(4)}
      {actual} = MatchingEngine.sell_limit_order(order, ob)
      assert expect == actual.tree_sell.data
      assert expect.price == actual.tree_sell.key
    end

    test "create buy limit order case matching sell price" do
      order = %Order{price: 10.5,volume: Decimal.new(4)}
      ob = %OrderBook{
        tree_buy: nil,
        tree_sell: RedBlackTree.insert(nil, %RedBlackTree{key: 10.5, data: %Order{price: 10.5,volume: Decimal.new(3)}})
      }

      expect = %Order{price: 10.5,volume: Decimal.new(1)}
      {actual} = MatchingEngine.buy_limit_order(order, ob)
      assert expect == actual.tree_buy.data
      assert expect.price == actual.tree_buy.key
    end

    test "create sell limit order case matching buy price" do
      order = %Order{price: 10.5,volume: Decimal.new(4)}
      ob = %OrderBook{
        tree_buy: RedBlackTree.insert(nil, %RedBlackTree{key: 10.5, data: %Order{price: 10.5,volume: Decimal.new(3)}}),
        tree_sell: nil
      }

      expect = %Order{price: 10.5,volume: Decimal.new(1)}
      {actual} = MatchingEngine.sell_limit_order(order, ob)
      assert expect == actual.tree_sell.data
      assert expect.price == actual.tree_sell.key
    end

  end
end
