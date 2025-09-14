defmodule Expencfy.Expenses.Category do
  @moduledoc """
  Defines the Category schema and changeset for expense categorization.

  Categories are used to organize and budget expenses. Each category has a name,
  description, and monthly budget amount. Categories can have multiple associated
  expenses through the `has_many` relationship.

  ## Fields

    * `:name` - The name of the category (required)
    * `:description` - A description of what expenses belong in this category (required)
    * `:monthly_budget` - The monthly budget amount for this category using Money type (required, must be > 0)

  ## Relationships

    * `has_many :expenses` - Associated expenses that belong to this category

  ## Examples

      iex> changeset = Category.changeset(%Category{}, %{
      ...>   name: "Groceries",
      ...>   description: "Food and household items",
      ...>   monthly_budget: Money.new(50000, :USD)
      ...> })
      iex> changeset.valid?
      true

  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "categories" do
    field :name, :string
    field :description, :string
    field :monthly_budget, Money.Ecto.Amount.Type

    has_many :expenses, Expencfy.Expenses.Expense

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name, :description, :monthly_budget])
    |> validate_required([:name, :description, :monthly_budget])
    |> validate_money(:monthly_budget)
  end

  defp validate_money(changeset, field) do
    validate_change(changeset, field, fn
      _, %Money{amount: amount} when amount > 0 -> []
      _, _ -> [monthly_budget: "must be greater than 0"]
    end)
  end
end
