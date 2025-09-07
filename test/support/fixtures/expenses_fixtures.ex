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
        monthly_budget: 4200,
        name: "some name"
      })
      |> Expencfy.Expenses.create_category()

    category
  end

  @doc """
  Generate an expense.
  """
  def expense_fixture(attrs \\ %{}) do
    category = Map.get(attrs, :category) || category_fixture()

    {:ok, expense} =
      attrs
      |> Enum.into(%{
        amount: 4200,
        date: ~D[2025-09-06],
        description: "some description",
        notes: "some notes",
        category_id: category.id
      })
      |> Expencfy.Expenses.create_expense()

    expense
  end
end
