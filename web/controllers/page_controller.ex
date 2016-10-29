defmodule Marc.PageController do
  use Marc.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def about(conn, _params) do
    render conn, "about.html"
  end

  def status(conn, _params) do
    text conn, "ok"
  end
end
