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

  def get_chapter_by_number(num) do
    GenServer.call __MODULE__, {:get_chapter_by_number, num}
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
    short_chapter_numbers = chapters
      |> Enum.with_index()
      |> Enum.map(    fn({s, i}) -> {String.length(s.text), i} end )
      |> Enum.filter( fn({sl, _}) -> sl < @short_chapter_max_length end )
      |> Enum.map(    fn({_, i}) -> i+1 end )
    {:ok, %{chapters: chapters,
            short_chapter_numbers: short_chapter_numbers,
            count: Enum.count(chapters)}}
  end

  def handle_call({:get_chapter_by_number, num}, _from, state) do
    chapter = get_chapter_view(state, num)
    {:reply, chapter, state}
  end

  def handle_call(:random, _from, %{count: count}=state) do
    num = :rand.uniform(count)
    random_chapter = get_chapter_view(state, num)
    {:reply, random_chapter, state}
  end

  def handle_call(:random_short_chapter, _from, state) do
    %{short_chapter_numbers: short_chapter_numbers} = state
    num = Enum.random(short_chapter_numbers)
    random_short_chapter = get_chapter_view(state, num)
    {:reply, random_short_chapter, state}
  end

  # Private Helpers
  defp get_chapter_view(%{chapters: chapters, count: count}, chapter_num) do
    case Enum.at(chapters, chapter_num-1) do
      nil ->
        nil
      chapter ->
        %{chapter: chapter,
          previous: if(chapter_num == 1,         do: nil, else: chapter_num - 1),
          next:     if(chapter_num == count, do: nil, else: chapter_num + 1)}
    end
  end

end
