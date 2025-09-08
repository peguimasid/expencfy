defmodule ExpencfyWeb.CategoryLive.Show do
  use ExpencfyWeb, :live_view

  alias Expencfy.Expenses

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Category {@category.id}
        <:subtitle>This is a category record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/categories"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/categories/#{@category}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit category
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Name">{@category.name}</:item>
        <:item title="Description">{@category.description}</:item>
        <:item title="Monthly budget">{@category.monthly_budget}</:item>
        <:item title="Total spent">{@total_spent}</:item>
        <:item title="Percent of budget spent">
          <div class="flex gap-4 items-center mt-2">
            <progress
              value={@percent_spent}
              max="100"
              class={[
                "progress w-full",
                @percent_spent >= 100 && "text-red-500"
              ]}
            />
            <span class="shrink-0">
              {@percent_spent}%
            </span>
          </div>
        </:item>
      </.list>

      <hr />

      <.header>Recent Expenses</.header>

      <div :if={@category.expenses == []} class="text-gray-500 italic">
        No expenses found for this category.
      </div>

      <.table :if={@category.expenses != []} id="expenses" rows={@category.expenses}>
        <:col :let={expense} label="Description">{expense.description}</:col>
        <:col :let={expense} label="Amount">{expense.amount}</:col>
        <:col :let={expense} label="Date">{expense.date}</:col>
        <:action :let={expense}>
          <.link navigate={~p"/expenses/#{expense}"}>Show</.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    category = Expenses.get_category_with_expenses!(id)
    total_spent = Enum.reduce(category.expenses, Money.new(0, :USD), &Money.add(&2, &1.amount))
    percent_spent = calculate_percent_spent(total_spent, category.monthly_budget)

    socket =
      assign(socket, %{
        page_title: "Show Category",
        category: category,
        total_spent: total_spent,
        percent_spent: percent_spent
      })

    {:ok, socket}
  end

  defp calculate_percent_spent(total_spent, monthly_budget) do
    budget_amount = monthly_budget |> Money.to_decimal() |> Decimal.to_float()
    total_spent = total_spent |> Money.to_decimal() |> Decimal.to_float()

    case budget_amount do
      amount when amount > 0 -> (total_spent / amount * 100) |> Float.round(1)
      _ -> 0.0
    end
  end
end
