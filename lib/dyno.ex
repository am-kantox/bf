defmodule Bf.Dyno do
  @moduledoc false

  use Tarearbol.DynamicManager

  @impl Tarearbol.DynamicManager
  def children_specs, do: %{}

  @impl Tarearbol.DynamicManager
  def perform(_index, _value), do: raise("Unexpected call")

  @impl Tarearbol.DynamicManager
  def call(:<, _from, {_id, value}), do: {:ok, value}
  def call(:-, _from, {_id, value}), do: {:replace, value - 1}
  def call(:+, _from, {_id, value}), do: {:replace, value + 1}
  def call({:>, value}, _from, {_id, _value}), do: {:replace, value}
end
