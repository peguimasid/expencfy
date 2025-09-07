defmodule Expencfy.Expenses.Category do
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
