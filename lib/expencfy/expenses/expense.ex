defmodule Expencfy.Expenses.Expense do
  use Ecto.Schema
  import Ecto.Changeset

  schema "expenses" do
    field :description, :string
    field :amount, :integer
    field :date, :date
    field :notes, :string
    field :category_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(expense, attrs) do
    expense
    |> cast(attrs, [:description, :amount, :date, :notes])
    |> validate_required([:description, :amount, :date, :notes])
  end
end
