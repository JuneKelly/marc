defmodule Marc.LayoutView do
  use Marc.Web, :view

  def site_name, do: Application.get_env(:marc, :site_name)
end
