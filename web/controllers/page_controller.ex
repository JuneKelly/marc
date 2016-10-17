defmodule Marc.PageController do
  use Marc.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
