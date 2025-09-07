defmodule Expencfy.Expenses.Expense do
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
  end
end
