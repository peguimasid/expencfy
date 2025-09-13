defmodule Expencfy.Expenses.Expense do
  use Ecto.Schema
  import Ecto.Changeset

  schema "expenses" do
    field :description, :string
    field :amount, Money.Ecto.Amount.Type
    field :date, :date
    field :notes, :string
    field :lock_version, :integer, default: 0
    belongs_to :category, Expencfy.Expenses.Category

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(expense, attrs) do
    expense
    |> cast(attrs, [:description, :amount, :date, :notes, :category_id, :lock_version])
    |> validate_required([:description, :amount, :date, :category_id])
    |> validate_money(:amount)
    |> optimistic_lock(:lock_version)
  end

  defp validate_money(changeset, field) do
    validate_change(changeset, field, fn
      _, %Money{amount: amount} when amount > 0 -> []
      _, _ -> [amount: "must be greater than 0"]
    end)
  end
end
