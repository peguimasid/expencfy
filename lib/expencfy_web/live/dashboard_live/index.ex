defmodule ExpencfyWeb.DashboardLive.Index do
  alias Expencfy.Expenses.Expense
  alias Expencfy.Expenses
  use ExpencfyWeb, :live_view

  # sticky inset-0 z-10 flex h-16 w-full border-b bg-card/80 backdrop-blur-sm
  @impl true
  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-base-100">
      <!-- Header -->
      <header class="border-b border-b-base-300 sticky inset-0 z-10 bg-base-200/80 backdrop-blur">
        <div class="container mx-auto px-4 py-4">
          <div class="flex items-center justify-between">
            <div class="flex items-center gap-3">
              <div class="flex h-10 w-10 items-center justify-center rounded-lg bg-primary text-primary-content">
                <.icon name="hero-currency-dollar" class="h-5 w-5" />
              </div>
              <div class="hidden sm:inline">
                <h1 class="text-lg font-bold">Expencfy</h1>
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
                        <%!-- <span class="font-medium">${@total_spent}</span> --%>
                        <span class="font-medium">$120</span>
                      </div>
                      <div class="flex justify-between text-sm">
                        <span class="text-base-content/70">Total Budget</span>
                        <%!-- <span class="font-medium">${@total_budget}</span> --%>
                        <span class="font-medium">$320</span>
                      </div>
                      <%!-- <progress
                        class="progress progress-primary w-full"
                        value={@overall_progress}
                        max="100"
                      /> --%>
                      <progress
                        class="progress progress-primary w-full"
                        value={95}
                        max="100"
                      />
                      <div class="flex justify-between text-xs text-base-content/70">
                        <%!-- <span>{@overall_progress}% used</span>
                        <span>${@remaining_budget} remaining</span> --%>
                        <span>95% used</span>
                        <span>$240 remaining</span>
                      </div>
                    </div>
                    <div class="divider my-2"></div>
                    <div class="flex items-center gap-2 text-sm">
                      <.icon name="hero-calendar-days" class="h-4 w-4 text-base-content/70" />
                      <span class="text-base-content/70">
                        {Timex.format!(Timex.today(), "{Mfull} {YYYY}")}
                      </span>
                    </div>
                  </div>
                </div>
              </div>
              
    <!-- Quick Actions -->
              <div class="card bg-base-200 shadow-sm">
                <div class="card-body">
                  <h2 class="card-title">Quick Actions</h2>
                  <div class="space-y-2">
                    <.link
                      navigate={~p"/categories/new"}
                      class="btn btn-secondary w-full justify-start gap-2"
                    >
                      <.icon name="hero-plus" class="h-4 w-4" /> New Category
                    </.link>
                    <.link
                      navigate={~p"/expenses"}
                      class="btn btn-secondary w-full justify-start gap-2"
                    >
                      <.icon name="hero-document-text" class="h-4 w-4" /> View All Expenses
                    </.link>
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
                  <div class="badge badge-soft badge-primary badge-sm gap-1 py-2">
                    <span>{length(@categories)}</span>
                    <span>categories</span>
                  </div>
                </div>
                <div class="grid gap-4 md:grid-cols-2">
                  <div
                    :for={category <- @categories}
                    id={"category-#{category.id}"}
                    class={[
                      "card cursor-pointer transition-all duration-200 hover:shadow-md",
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
                        <.link
                          navigate={~p"/categories/#{category.id}"}
                          class="btn btn-ghost btn-xs btn-circle"
                        >
                          <.icon name="hero-eye" class="size-4" />
                        </.link>
                      </div>

                      <div class="mt-4 space-y-2">
                        <div class="flex justify-between text-sm">
                          <span class="text-base-content/70">Spent</span>
                          <span class="font-medium">$0</span>
                          <%!-- <span class="font-medium">${category.spent}</span> --%>
                        </div>
                        <%!-- <progress
                      class="progress progress-primary w-full"
                      value={category.spent / category.monthly_budget * 100}
                      max="100"
                    </progress>
                    > --%>
                        <div class="flex justify-between text-xs text-base-content/70">
                          <%!-- <span>${category.spent} of ${category.monthly_budget}</span> --%>
                          <%!-- <span>{trunc(category.spent / category.monthly_budget * 100)}%</span> --%>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              
    <!-- Recent Expenses -->
              <div class="card bg-base-200 shadow-sm">
                <div class="card-body">
                  <div class="flex items-center justify-between mb-4">
                    <h2 class="card-title flex items-center gap-2">
                      <.icon name="hero-calendar-days" class="h-5 w-5" /> This Month's Expenses
                    </h2>
                    <div class="badge badge-soft badge-primary badge-sm gap-1 py-2">
                      <span>{length(@recent_expenses)}</span>
                      <span>expenses</span>
                    </div>
                  </div>
                  <div class="space-y-2">
                    <div
                      :for={expense <- @recent_expenses}
                      class="flex items-center justify-between p-3 bg-base-100 rounded-lg relative"
                    >
                      <div class="absolute left-0 w-1 h-full bg-primary rounded-l-full" />

                      <div class="flex items-center gap-3 ml-3">
                        <div>
                          <p class="font-medium">
                            {expense.description}
                            <span class="font-normal hidden sm:inline text-zinc-400">
                              • {expense.category.name}
                            </span>
                          </p>
                          <p class="text-sm text-base-content/70">
                            {format_relative_date(expense.date)}
                          </p>
                        </div>
                      </div>
                      <div class="flex items-center gap-2">
                        <span class="font-medium">{expense.amount}</span>
                        <.link
                          navigate={~p"/expenses/#{expense.id}"}
                          class="btn btn-ghost btn-sm"
                        >
                          Show
                        </.link>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div :if={@show_expense_form} class="modal backdrop-blur-xs modal-open">
        <div class="modal-box border border-base-300">
          <h3 class="font-bold text-lg mb-4">Add New Expense</h3>
          <.form for={@form} id="expense-form" phx-change="validate" phx-submit="save">
            <div class="space-y-4">
              <.input field={@form[:description]} type="text" label="Description" />
              <.input field={@form[:amount]} type="number" label="Amount" step="0.01" />
              <.input
                field={@form[:category_id]}
                type="select"
                label="Category"
                options={Expenses.category_names_and_ids()}
              />
              <div class="flex flex-col gap-0.5 fieldset">
                <div class="flex flex-row w-full justify-between">
                  <span class="label">Date</span>
                  <span class="label">{format_relative_date(@form[:date].value)}</span>
                </div>
                <.input
                  field={@form[:date]}
                  type="date"
                />
              </div>
              <.input field={@form[:notes]} type="textarea" label="Notes (optional)" />
            </div>
            <div class="modal-action">
              <button type="button" class="btn" phx-click="close_expense_form">Cancel</button>
              <button type="submit" class="btn btn-primary">Add Expense</button>
            </div>
          </.form>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    categories = Expenses.list_categories()
    expenses = Expenses.list_expenses_current_month()

    expense = %Expense{date: Date.utc_today()}

    socket =
      socket
      |> assign(:categories, categories)
      |> assign(:recent_expenses, expenses)
      |> assign(:selected_category, nil)
      |> assign(:show_expense_form, false)
      |> assign(:form, to_form(Expenses.change_expense(expense)))

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
      |> assign(:form, to_form(%{}))

    {:noreply, socket}
  end

  @impl true
  def handle_event("validate", _params, socket) do
    # Add validation logic here if needed
    {:noreply, socket}
  end

  @impl true
  def handle_event("save", expense_params, socket) do
    # Add save logic here
    IO.inspect(expense_params, label: "New expense")

    socket =
      socket
      |> assign(:show_expense_form, false)
      |> assign(:form, to_form(%{}))

    {:noreply, socket}
  end

  defp format_relative_date(%Date{} = date) do
    case Timex.diff(date, Timex.today(), :days) do
      -1 -> "Yesterday"
      0 -> "Today"
      1 -> "Tomorrow"
      _ -> Timex.format!(date, "{relative}", :relative)
    end
  end

  defp format_relative_date(_), do: ""
end
