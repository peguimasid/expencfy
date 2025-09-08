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
      </.list>

      <hr />

      <.header>
        Recent Expenses
      </.header>

      <div :if={Enum.empty?(@category.expenses)} class="text-gray-500 italic">
        No expenses found for this category.
      </div>

      <.table :if={not Enum.empty?(@category.expenses)} id="expenses" rows={@category.expenses}>
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
    socket =
      socket
      |> assign(:page_title, "Show Category")
      |> assign(:category, Expenses.get_category_with_expenses!(id))

    {:ok, socket}
  end
end
