defmodule Marc.PageController do
  use Marc.Web, :controller

  def index(conn, _params) do
    chapter_view = Marc.Meditations.random_chapter
    render conn, "index.html", chapter_view: chapter_view
  end

  def about(conn, _params) do
    render conn, "about.html"
  end

  def status(conn, _params) do
    text conn, "ok"
  end
end
