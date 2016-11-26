defmodule Marc.MeditationsMarkdown do
  use GenServer

  @markdown_file "resources/meditations.md"

  # Public API
  def get_markdown do
    GenServer.call __MODULE__, :get_markdown
  end

  def get_clean_markdown do
    GenServer.call __MODULE__, :get_clean_markdown
  end

  # GenServer API
  def start_link do
    GenServer.start_link __MODULE__, [], name: __MODULE__
  end

  def init([]) do
    {:ok, raw} = File.read @markdown_file
    cleaned = String.replace raw, ~r/^{:.*}\n/mU, ""
    {:ok, %{markdown: raw,
            clean_markdown: cleaned}}
  end

  def handle_call(:get_markdown, _from, %{markdown: markdown}=state) do
    {:reply, markdown, state}
  end

  def handle_call(:get_clean_markdown, _from, %{clean_markdown: clean_markdown}=state) do
    {:reply, clean_markdown, state}
  end

end
