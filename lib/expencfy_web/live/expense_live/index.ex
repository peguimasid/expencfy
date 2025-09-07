defmodule ExpencfyWeb.ExpenseLive.Index do
  use ExpencfyWeb, :live_view

  alias Expencfy.Expenses

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Expenses
        <:actions>
          <.button variant="primary" navigate={~p"/expenses/new"}>
            <.icon name="hero-plus" /> New Expense
          </.button>
        </:actions>
      </.header>

      <.table
        id="expenses"
        rows={@streams.expenses}
        row_click={fn {_id, expense} -> JS.navigate(~p"/expenses/#{expense}") end}
      >
        <:col :let={{_id, expense}} label="Description">{expense.description}</:col>
        <:col :let={{_id, expense}} label="Amount">{expense.amount}</:col>
        <:col :let={{_id, expense}} label="Date">{expense.date}</:col>
        <:col :let={{_id, expense}} label="Notes">{expense.notes}</:col>
        <:action :let={{_id, expense}}>
          <div class="sr-only">
            <.link navigate={~p"/expenses/#{expense}"}>Show</.link>
          </div>
          <.link navigate={~p"/expenses/#{expense}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, expense}}>
          <.link
            phx-click={JS.push("delete", value: %{id: expense.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Listing Expenses")
     |> stream(:expenses, list_expenses())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    expense = Expenses.get_expense!(id)
    {:ok, _} = Expenses.delete_expense(expense)

    {:noreply, stream_delete(socket, :expenses, expense)}
  end

  defp list_expenses() do
    Expenses.list_expenses()
  end
end
