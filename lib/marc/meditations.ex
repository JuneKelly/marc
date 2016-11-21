defmodule Marc.Meditations do
  use GenServer

  @data_file     "resources/meditations_flat.json"
  @short_chapter_max_length 900

  # Public API

  def random_chapter do
    GenServer.call __MODULE__, :random
  end

  def random_short_chapter do
    GenServer.call __MODULE__, :random_short_chapter
  end

  def get_chapter_by_index(index) do
    GenServer.call __MODULE__, {:get_by_index, index}
  end

  # GenServer API

  def start_link do
    start_link @data_file
  end

  def start_link(data_file) do
    GenServer.start_link __MODULE__, [data_file], name: __MODULE__
  end

  def init([data_file]) do
    {:ok, raw} = File.read data_file
    {:ok, chapters} = Poison.decode raw, keys: :atoms
    short_chapter_indices = chapters
      |> Enum.with_index()
      |> Enum.map(    fn({s, i}) -> {String.length(s.text), i} end )
      |> Enum.filter( fn({sl, _}) -> sl < @short_chapter_max_length end )
      |> Enum.map(    fn({_, i}) -> i end )
    {:ok, %{chapters: chapters,
            short_chapter_indices: short_chapter_indices,
            count: Enum.count(chapters)}}
  end

  def handle_call({:get_by_index, index}, _from, state) do
    chapter = get_chapter_view(state, index)
    {:reply, chapter, state}
  end

  def handle_call(:random, _from, %{count: count}=state) do
    index = :rand.uniform(count - 1)
    random_chapter = get_chapter_view(state, index)
    {:reply, random_chapter, state}
  end

  def handle_call(:random_short_chapter, _from, state) do
    %{short_chapter_indices: short_chapter_indices} = state
    index = Enum.random(short_chapter_indices)
    random_short_chapter = get_chapter_view(state, index)
    {:reply, random_short_chapter, state}
  end

  # Private Helpers
  defp get_chapter_view(%{chapters: chapters, count: count}, index) do
    case Enum.at(chapters, index) do
      nil ->
        nil
      chapter ->
        %{chapter: chapter,
          previous: if(index == 0,         do: nil, else: index - 1),
          next:     if(index == count - 1, do: nil, else: index + 1)}
    end
  end

end
