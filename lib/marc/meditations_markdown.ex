defmodule Marc.MeditationsMarkdown do
  use GenServer

  @markdown_file "resources/meditations.md"

  # Public API
  def get_markdown do
    GenServer.call __MODULE__, :get_markdown
  end

  # GenServer API
  def start_link do
    GenServer.start_link __MODULE__, [], name: __MODULE__
  end

  def init([]) do
    {:ok, raw} = File.read @markdown_file
    {:ok, %{markdown: raw}}
  end

  def handle_call(:get_markdown, _from, %{markdown: markdown}=state) do
    {:reply, markdown, state}
  end

end
