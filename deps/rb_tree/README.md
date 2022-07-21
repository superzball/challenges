# RedBlackTree

[![Build Status](https://travis-ci.com/herbstrith/rb_tree.svg?branch=master)](https://travis-ci.com/herbstrith/rb_tree)
[![Coverage Status](https://coveralls.io/repos/github/herbstrith/rb_tree/badge.svg?branch=master)](https://coveralls.io/github/herbstrith/rb_tree?branch=master)

Module for creating and managing red-black trees.
Tree nodes have keys (a number that defines the relation between nodes) and data (anything you want).

A red-black tree is a approximately balanced binary tree that satisfies the following red-black properties:
1. Every node is either red or black.
2. The root is black.   * We relax this rule as per to make deletion simpler in the functional realm
3. Every leaf (NIL) is black.
4. If a node is red, then both its children are black.
5. For each node, all simple paths from the node to descendant leaves contain the
  same number of black nodes.

Using the implementantion of insert from the article
"Red-black trees in a functional setting" by Chris Okasaki

Using the delete implementation from the article
"FUNCTIONAL PEARL Deletion: The curse of the red-black tree" by Kimball Germane and Matthew Might
## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `rb_tree` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:rb_tree, "~> 1.0.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/rb_tree](https://hexdocs.pm/rb_tree).

