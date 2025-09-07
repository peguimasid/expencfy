defmodule ExpencfyWeb.DashboardLive.Index do
  use ExpencfyWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex px-4 py-10 sm:px-6 sm:py-28 lg:px-8 xl:px-28 xl:py-32">
      <div class="mx-auto max-w-xl">
        <div class="mt-10 flex justify-between items-center">
          <Layouts.theme_toggle />
        </div>

        <p class="text-[2rem] mt-4 font-semibold flex items-center gap-2 leading-10 tracking-tighter text-balance">
          <.icon name="hero-document-currency-dollar" class="size-10" />
          Simplify your finances with Expencfy.
        </p>
        <p class="mt-4 leading-7 text-base-content/70">
          Track expenses, manage budgets, and gain insights into your spending habits. Built with Phoenix LiveView for real-time updates.
        </p>

        <div class="mt-8 flex space-x-4">
          <a href={~p"/categories"} class="btn btn-primary">
            Manage Categories
          </a>
          <a href={~p"/expenses"} class="btn btn-secondary">
            Manage Expenses
          </a>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
