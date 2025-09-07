defmodule ExpencfyWeb.ExpenseLive.Show do
  use ExpencfyWeb, :live_view

  alias Expencfy.Expenses

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Expense {@expense.id}
        <:subtitle>This is a expense record from your database.</:subtitle>
        <:actions>
          <.button navigate={@return_to}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/expenses/#{@expense}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit expense
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Description">{@expense.description}</:item>
        <:item title="Amount">{@expense.amount}</:item>
        <:item title="Date">{@expense.date}</:item>
        <:item title="Category">
          <.link
            navigate={~p"/categories/#{@expense.category}?return_to=/expenses/#{@expense}"}
            class="text-blue-600 hover:text-blue-800 underline"
          >
            {@expense.category.name}
          </.link>
        </:item>
        <:item title="Notes">{@expense.notes}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id} = params, _session, socket) do
    return_to = Map.get(params, "return_to", ~p"/expenses")

    socket =
      socket
      |> assign(:page_title, "Show Expense")
      |> assign(:expense, Expenses.get_expense!(id))
      |> assign(:return_to, return_to)

    {:ok, socket}
  end
end
