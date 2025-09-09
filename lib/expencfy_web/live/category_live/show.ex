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

      <div :if={@streams.expenses == []} class="text-gray-500 italic">
        No expenses found for this category.
      </div>

      <.table :if={@streams.expenses != []} id="expenses" rows={@streams.expenses}>
        <:col :let={{_id, expense}} label="Description">{expense.description}</:col>
        <:col :let={{_id, expense}} label="Amount">{expense.amount}</:col>
        <:col :let={{_id, expense}} label="Date">{expense.date}</:col>
        <:action :let={{_id, expense}}>
          <.link navigate={~p"/expenses/#{expense}"}>Show</.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    if connected?(socket) do
      Expenses.subscribe()
    end

    category = Expenses.get_category_with_expenses!(id)
    total_spent = Enum.reduce(category.expenses, Money.new(0, :USD), &Money.add(&2, &1.amount))
    percent_spent = calculate_percent_spent(total_spent, category.monthly_budget)

    {:ok,
     socket
     |> assign(:page_title, "Show Category")
     |> assign(:category, category)
     |> assign(:total_spent, total_spent)
     |> assign(:percent_spent, percent_spent)
     |> stream(:expenses, category.expenses)}
  end

  @impl true
  def handle_info({:expense_created, expense}, socket) do
    IO.inspect(expense, label: "Expense created")
    # {:noreply, stream_insert(socket, :expenses, expense, at: 0)}
    {:noreply, socket}
  end

  @impl true
  def handle_info({:expense_updated, expense}, socket) do
    IO.inspect(expense, label: "Expense updated")
    # {:noreply, stream_insert(socket, :expenses, expense)}
    {:noreply, socket}
  end

  @impl true
  def handle_info({:expense_deleted, expense}, socket) do
    IO.inspect(expense, label: "Expense deleted")
    # {:noreply, stream_delete(socket, :expenses, expense)}
    {:noreply, socket}
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
