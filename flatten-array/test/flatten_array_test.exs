defmodule FlattenArrayTest do
  use ExUnit.Case

  test "empty" do
    assert FlattenArray.flatten([]) ==
             []
  end

  test "no nesting" do
    assert FlattenArray.flatten([0, 1, 2]) ==
             [0, 1, 2]
  end

  test "flattens a nested array" do
    assert FlattenArray.flatten([[[]]]) ==
             []
  end

  test "flattens array with just integers present" do
    assert FlattenArray.flatten([1, [2, 3, 4, 5, 6, 7], 8]) ==
             [1, 2, 3, 4, 5, 6, 7, 8]
  end

  test "5 level nesting" do
    assert FlattenArray.flatten([0, 2, [[2, 3], 8, 100, 4, [[[50]]]], -2]) ==
             [0, 2, 2, 3, 8, 100, 4, 50, -2]
  end

  test "6 level nesting" do
    assert FlattenArray.flatten([1, [2, [[3]], [4, [[5]]], 6, 7], 8]) ==
             [1, 2, 3, 4, 5, 6, 7, 8]
  end

  test "nil values values are omitted from the final result" do
    assert FlattenArray.flatten([1, 2, nil]) ==
             [1, 2]
  end

  test "consecutive nil values at the front of the list are omitted from the final result" do
    assert FlattenArray.flatten([nil, nil, 3]) ==
             [3]
  end

  test "consecutive nil values in the middle of the list are omitted from the final result" do
    assert FlattenArray.flatten([1, nil, nil, 4]) ==
             [1, 4]
  end

  test "6 level nesting with nil values" do
    assert FlattenArray.flatten([0, 2, [[2, 3], 8, [[100]], nil, [[nil]]], -2]) ==
             [0, 2, 2, 3, 8, 100, -2]
  end

  test "all values in nested list are null" do
    assert FlattenArray.flatten([nil, [[[nil]]], nil, nil, [[nil, nil], nil], nil]) ==
             []
  end
end
