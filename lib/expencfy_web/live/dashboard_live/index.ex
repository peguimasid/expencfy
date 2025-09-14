defmodule ExpencfyWeb.DashboardLive.Index do
  use ExpencfyWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-base-100">
      <!-- Header -->
      <header class="border-b border-b-base-300 bg-base-200/50 backdrop-blur">
        <div class="container mx-auto px-4 py-4">
          <div class="flex items-center justify-between">
            <div class="flex items-center gap-3">
              <div class="flex h-10 w-10 items-center justify-center rounded-lg bg-primary text-primary-content">
                <.icon name="hero-currency-dollar" class="h-5 w-5" />
              </div>
              <div>
                <h1 class="text-2xl font-bold">Expense Tracker</h1>
                <p class="text-sm text-base-content/70">Manage your budget and expenses</p>
              </div>
            </div>
            <div class="flex items-center gap-2">
              <Layouts.theme_toggle />
              <button
                class="btn btn-primary gap-2"
                phx-click="show_expense_form"
              >
                <.icon name="hero-plus" class="h-4 w-4" /> Add Expense
              </button>
            </div>
          </div>
        </div>
      </header>

      <div class="container mx-auto px-4 py-6">
        <div class="grid gap-6 lg:grid-cols-4">
          <!-- Sidebar -->
          <div class="lg:col-span-1">
            <div class="space-y-6">
              <!-- Overview Card -->
              <div class="card bg-base-200 shadow-sm">
                <div class="card-body">
                  <h2 class="card-title flex items-center gap-2">
                    <.icon name="hero-chart-bar" class="h-5 w-5" /> Monthly Overview
                  </h2>
                  <div class="space-y-4">
                    <div class="space-y-2">
                      <div class="flex justify-between text-sm">
                        <span class="text-base-content/70">Total Spent</span>
                        <span class="font-medium">${@total_spent}</span>
                      </div>
                      <div class="flex justify-between text-sm">
                        <span class="text-base-content/70">Total Budget</span>
                        <span class="font-medium">${@total_budget}</span>
                      </div>
                      <progress
                        class="progress progress-primary w-full"
                        value={@overall_progress}
                        max="100"
                      >
                      </progress>
                      <div class="flex justify-between text-xs text-base-content/70">
                        <span>{@overall_progress}% used</span>
                        <span>${@remaining_budget} remaining</span>
                      </div>
                    </div>
                    <div class="divider my-2"></div>
                    <div class="flex items-center gap-2 text-sm">
                      <.icon name="hero-calendar" class="h-4 w-4 text-base-content/70" />
                      <span class="text-base-content/70">January 2024</span>
                    </div>
                  </div>
                </div>
              </div>
              
    <!-- Quick Actions -->
              <div class="card bg-base-200 shadow-sm">
                <div class="card-body">
                  <h2 class="card-title">Quick Actions</h2>
                  <div class="space-y-2">
                    <button class="btn btn-outline btn-block justify-start gap-2">
                      <.icon name="hero-plus" class="h-4 w-4" /> New Category
                    </button>
                    <button class="btn btn-outline btn-block justify-start gap-2">
                      <.icon name="hero-document-text" class="h-4 w-4" /> View All Expenses
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>
          
    <!-- Main Content -->
          <div class="lg:col-span-3">
            <div class="space-y-6">
              <!-- Categories Grid -->
              <div>
                <div class="mb-4 flex items-center justify-between">
                  <h2 class="text-xl font-semibold">Budget Categories</h2>
                  <div class="badge badge-soft gap-1 px-2">
                    <span>{length(@categories)}</span>
                    <span>categories</span>
                  </div>
                </div>
                <div class="grid gap-4 md:grid-cols-2">
                  <div
                    :for={category <- @categories}
                    id={"category-#{category.id}"}
                    class={[
                      "card cursor-pointer transition-all duration-200 hover:shadow-lg",
                      if(@selected_category == category.id,
                        do: "bg-primary/10 border-primary",
                        else: "bg-base-200"
                      )
                    ]}
                    phx-click="select_category"
                    phx-value-id={category.id}
                  >
                    <div class="card-body">
                      <div class="flex items-start justify-between">
                        <div class="flex-1">
                          <h3 class="font-semibold">{category.name}</h3>
                          <p class="text-sm text-base-content/70 mt-1">{category.description}</p>
                        </div>
                        <div class={"w-3 h-3 rounded-full #{category.color}"}></div>
                      </div>

                      <div class="mt-4 space-y-2">
                        <div class="flex justify-between text-sm">
                          <span class="text-base-content/70">Spent</span>
                          <span class="font-medium">${category.spent}</span>
                        </div>
                        <progress
                          class="progress progress-primary w-full"
                          value={category.spent / category.monthly_budget * 100}
                          max="100"
                        >
                        </progress>
                        <div class="flex justify-between text-xs text-base-content/70">
                          <span>${category.spent} of ${category.monthly_budget}</span>
                          <span>{trunc(category.spent / category.monthly_budget * 100)}%</span>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              
    <!-- Recent Expenses -->
              <div class="card bg-base-200 shadow-sm">
                <div class="card-body">
                  <h2 class="card-title">Recent Expenses</h2>
                  <div class="space-y-2">
                    <div
                      :for={expense <- @recent_expenses}
                      class="flex items-center justify-between p-3 bg-base-100 rounded-lg"
                    >
                      <div class="flex items-center gap-3">
                        <div class={"w-2 h-2 rounded-full #{get_category_color(@categories, expense.category_id)}"}>
                        </div>
                        <div>
                          <p class="font-medium">{expense.description}</p>
                          <p class="text-sm text-base-content/70">{expense.date}</p>
                        </div>
                      </div>
                      <span class="font-medium">${expense.amount}</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      
    <!-- Expense Form Modal -->
      <%= if @show_expense_form do %>
        <div class="modal modal-open">
          <div class="modal-box">
            <h3 class="font-bold text-lg mb-4">Add New Expense</h3>
            <.form for={@form} id="expense-form" phx-change="validate" phx-submit="save">
              <div class="space-y-4">
                <.input field={@form[:description]} type="text" label="Description" />
                <.input field={@form[:amount]} type="number" label="Amount" step="0.01" />
                <.input
                  field={@form[:category_id]}
                  type="select"
                  label="Category"
                  options={category_options(@categories)}
                />
                <.input field={@form[:date]} type="date" label="Date" />
                <.input field={@form[:notes]} type="textarea" label="Notes (optional)" />
              </div>
              <div class="modal-action">
                <button type="button" class="btn" phx-click="close_expense_form">Cancel</button>
                <button type="submit" class="btn btn-primary">Add Expense</button>
              </div>
            </.form>
          </div>
        </div>
      <% end %>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    categories = [
      %{
        id: "1",
        name: "Food & Dining",
        description: "Groceries, restaurants, and food delivery",
        monthly_budget: 800.0,
        spent: 456.78,
        color: "bg-red-500"
      },
      %{
        id: "2",
        name: "Transportation",
        description: "Gas, public transit, rideshare",
        monthly_budget: 300.0,
        spent: 189.5,
        color: "bg-blue-500"
      },
      %{
        id: "3",
        name: "Entertainment",
        description: "Movies, games, subscriptions",
        monthly_budget: 200.0,
        spent: 145.99,
        color: "bg-green-500"
      },
      %{
        id: "4",
        name: "Shopping",
        description: "Clothing, electronics, miscellaneous",
        monthly_budget: 400.0,
        spent: 234.67,
        color: "bg-purple-500"
      }
    ]

    recent_expenses = [
      %{
        id: "1",
        category_id: "1",
        description: "Grocery shopping",
        amount: 89.45,
        date: "2024-01-15",
        notes: "Weekly groceries"
      },
      %{
        id: "2",
        category_id: "2",
        description: "Gas station",
        amount: 45.2,
        date: "2024-01-14"
      },
      %{
        id: "3",
        category_id: "3",
        description: "Netflix subscription",
        amount: 15.99,
        date: "2024-01-13"
      }
    ]

    total_budget = Enum.reduce(categories, 0, fn cat, acc -> acc + cat.monthly_budget end)
    total_spent = Enum.reduce(categories, 0, fn cat, acc -> acc + cat.spent end)
    overall_progress = trunc(total_spent / total_budget * 100)
    remaining_budget = Float.round(total_budget - total_spent, 2)

    socket =
      socket
      |> assign(:categories, categories)
      |> assign(:recent_expenses, recent_expenses)
      |> assign(:total_budget, Float.round(total_budget, 2))
      |> assign(:total_spent, Float.round(total_spent, 2))
      |> assign(:overall_progress, overall_progress)
      |> assign(:remaining_budget, remaining_budget)
      |> assign(:selected_category, nil)
      |> assign(:show_expense_form, false)
      |> assign(:form, to_form(%{}))

    {:ok, socket}
  end

  @impl true
  def handle_event("select_category", %{"id" => id}, socket) do
    {:noreply, assign(socket, :selected_category, id)}
  end

  @impl true
  def handle_event("show_expense_form", _params, socket) do
    {:noreply, assign(socket, :show_expense_form, true)}
  end

  @impl true
  def handle_event("close_expense_form", _params, socket) do
    socket =
      socket
      |> assign(:show_expense_form, false)
      |> assign(:form, to_form({}))

    {:noreply, socket}
  end

  @impl true
  def handle_event("validate", %{"expense" => expense_params}, socket) do
    # Add validation logic here if needed
    {:noreply, socket}
  end

  @impl true
  def handle_event("save", %{"expense" => expense_params}, socket) do
    # Add save logic here
    IO.inspect(expense_params, label: "New expense")

    socket =
      socket
      |> assign(:show_expense_form, false)
      |> assign(:form, to_form({}))

    {:noreply, socket}
  end

  defp get_category_color(categories, category_id) do
    category = Enum.find(categories, fn cat -> cat.id == category_id end)
    if category, do: category.color, else: "bg-gray-500"
  end

  defp category_options(categories) do
    Enum.map(categories, fn cat -> {cat.name, cat.id} end)
  end
end
