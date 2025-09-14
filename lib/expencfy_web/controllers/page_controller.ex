defmodule ExpencfyWeb.PageController do
  use ExpencfyWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
