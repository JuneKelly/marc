defmodule Marc.Meditations do
  use GenServer

  @data_file     "resources/meditations.json"
  @short_chapter_max_length 900

  # Public API

  def random_chapter() do
    GenServer.call __MODULE__, :random
  end

  def random_short_chapter() do
    GenServer.call __MODULE__, :random_short_chapter
  end

  def get_chapter_by_number(num) do
    GenServer.call __MODULE__, {:get_chapter_by_number, num}
  end

  def meditations() do
    GenServer.call __MODULE__, :meditations
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
    {:ok, meditations_data} = Poison.decode raw, keys: :atoms
    chapters = Meditations.Data.flatten(meditations_data)
    short_chapter_numbers = chapters
      |> Enum.with_index()
      |> Enum.map(    fn({s, i}) -> {String.length(s.text), i} end )
      |> Enum.filter( fn({sl, _}) -> sl < @short_chapter_max_length end )
      |> Enum.map(    fn({_, i}) -> i+1 end )
    markdown_text = Meditations.Data.meditations_to_markdown(meditations_data)
    {:ok,
     %{raw_json: raw,
       meditations: meditations_data,
       markdown_text: markdown_text,
       flat: %{
         chapter_list: chapters,
         short_chapter_numbers: short_chapter_numbers,
         count: Enum.count(chapters)
       }}}
  end

  def handle_call({:get_chapter_by_number, num}, _from, state) do
    chapter = get_chapter_view(state, num)
    {:reply, chapter, state}
  end

  def handle_call(:meditations, _from, %{meditations: meditations}=state) do
    {:reply, meditations, state}
  end

  def handle_call(:random, _from, state) do
    %{flat: %{count: count}} = state
    num = :rand.uniform(count)
    random_chapter = get_chapter_view(state, num)
    {:reply, random_chapter, state}
  end

  def handle_call(:random_short_chapter, _from, state) do
    %{flat: %{short_chapter_numbers: short_chapter_numbers}} = state
    num = Enum.random(short_chapter_numbers)
    random_short_chapter = get_chapter_view(state, num)
    {:reply, random_short_chapter, state}
  end

  # Private Helpers
  defp get_chapter_view(%{flat: %{chapter_list: chapters, count: count}}, chapter_num) do
    case chapter_num <= 0 do
      true ->
        nil
      _ ->
        case Enum.at(chapters, chapter_num-1) do
          nil ->
            nil
          chapter ->
            %{chapter: chapter,
              chapter_number: chapter_num,
              previous: if(chapter_num == 1,         do: nil, else: chapter_num - 1),
              next:     if(chapter_num == count, do: nil, else: chapter_num + 1)}
        end
    end
  end

end
