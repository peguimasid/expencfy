defmodule Expencfy.ExpensesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Expencfy.Expenses` context.
  """

  @doc """
  Generate a category.
  """
  def category_fixture(attrs \\ %{}) do
    {:ok, category} =
      attrs
      |> Enum.into(%{
        description: "some description",
        monthly_budget: 42,
        name: "some name"
      })
      |> Expencfy.Expenses.create_category()

    category
  end
end
