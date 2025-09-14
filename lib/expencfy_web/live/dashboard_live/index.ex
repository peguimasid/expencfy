defmodule ExpencfyWeb.DashboardLive.Index do
  use ExpencfyWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="flex px-4 py-10 sm:px-6 sm:py-28 lg:px-8 xl:px-28 xl:py-32">
        This is the dashboard
      </div>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
