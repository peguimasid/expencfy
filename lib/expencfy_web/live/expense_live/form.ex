defmodule ExpencfyWeb.ExpenseLive.Form do
  use ExpencfyWeb, :live_view

  alias Expencfy.Expenses
  alias Expencfy.Expenses.Expense

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage expense records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="expense-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:description]} type="text" label="Description" />
        <.input
          field={@form[:amount]}
          value={money_to_decimal(Phoenix.HTML.Form.input_value(@form, :amount))}
          type="number"
          label="Amount ($)"
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
        <.input field={@form[:notes]} type="textarea" label="Notes" />
        <.input
          field={@form[:category_id]}
          type="select"
          label="Category"
          options={@category_options}
        />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Expense</.button>
          <.button navigate={return_path(@return_to, @expense)}>Cancel</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> assign(:category_options, Expenses.category_names_and_ids())
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    expense = Expenses.get_expense!(id)

    socket
    |> assign(:page_title, "Edit Expense")
    |> assign(:expense, expense)
    |> assign(:form, to_form(Expenses.change_expense(expense)))
  end

  defp apply_action(socket, :new, _params) do
    expense = %Expense{date: Date.utc_today()}

    socket
    |> assign(:page_title, "New Expense")
    |> assign(:expense, expense)
    |> assign(:form, to_form(Expenses.change_expense(expense)))
  end

  @impl true
  def handle_event("validate", %{"expense" => expense_params}, socket) do
    changeset = Expenses.change_expense(socket.assigns.expense, expense_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"expense" => expense_params}, socket) do
    save_expense(socket, socket.assigns.live_action, expense_params)
  end

  defp save_expense(socket, :edit, expense_params) do
    case Expenses.update_expense(socket.assigns.expense, expense_params) do
      {:ok, expense} ->
        {:noreply,
         socket
         |> put_flash(:success, "Expense updated successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, expense))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_expense(socket, :new, expense_params) do
    case Expenses.create_expense(expense_params) do
      {:ok, expense} ->
        {:noreply,
         socket
         |> put_flash(:success, "Expense created successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, expense))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path("index", _expense), do: ~p"/expenses"
  defp return_path("show", expense), do: ~p"/expenses/#{expense}"

  defp money_to_decimal(%Money{} = input_value) do
    Money.to_decimal(input_value)
  end

  defp money_to_decimal(input_value) do
    input_value
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
