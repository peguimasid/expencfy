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

  @doc """
  Generate a expense.
  """
  def expense_fixture(attrs \\ %{}) do
    {:ok, expense} =
      attrs
      |> Enum.into(%{
        amount: 42,
        date: ~D[2025-09-06],
        description: "some description",
        notes: "some notes"
      })
      |> Expencfy.Expenses.create_expense()

    expense
  end
end
