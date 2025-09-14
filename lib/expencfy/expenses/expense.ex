defmodule Expencfy.Expenses.Expense do
  @moduledoc """
  Expense schema for managing financial expenses in the Expencfy application.

  This module defines the database schema and validation logic for expense records.
  Each expense contains a description, monetary amount, date, optional notes, and
  belongs to a category for organization purposes.

  The expense amount is stored using the Money library to ensure proper handling
  of currency and decimal precision.
  """

  @doc """
  Creates a changeset for expense validation and database operations.

  Validates that all required fields are present and that the monetary amount
  is greater than zero.

  ## Parameters
    * `expense` - The expense struct to create a changeset for
    * `attrs` - A map of attributes to validate and cast

  ## Returns
    * `%Ecto.Changeset{}` - A changeset with validation results

  ## Examples
      iex> changeset(%Expense{}, %{description: "Coffee", amount: Money.new(500), date: ~D[2023-01-01], category_id: 1})
      %Ecto.Changeset{valid?: true, ...}

      iex> changeset(%Expense{}, %{description: "Coffee"})
      %Ecto.Changeset{valid?: false, ...}
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "expenses" do
    field :description, :string
    field :amount, Money.Ecto.Amount.Type
    field :date, :date
    field :notes, :string
    belongs_to :category, Expencfy.Expenses.Category

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(expense, attrs) do
    expense
    |> cast(attrs, [:description, :amount, :date, :notes, :category_id])
    |> validate_required([:description, :amount, :date, :category_id])
    |> validate_money(:amount)
  end

  defp validate_money(changeset, field) do
    validate_change(changeset, field, fn
      _, %Money{amount: amount} when amount > 0 -> []
      _, _ -> [amount: "must be greater than 0"]
    end)
  end
end
