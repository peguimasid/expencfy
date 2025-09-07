defmodule ExpencfyWeb.Router do
  use ExpencfyWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ExpencfyWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ExpencfyWeb do
    pipe_through :browser

    live "/", CategoryLive.Index, :index
    live "/categories/new", CategoryLive.Form, :new
    live "/categories/:id", CategoryLive.Show, :show
    live "/categories/:id/edit", CategoryLive.Form, :edit
    live "/expenses", ExpenseLive.Index, :index
    live "/expenses/new", ExpenseLive.Form, :new
    live "/expenses/:id", ExpenseLive.Show, :show
    live "/expenses/:id/edit", ExpenseLive.Form, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", ExpencfyWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:expencfy, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ExpencfyWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
