defmodule Meditations.Data do

  def flatten(meditations) do
    List.flatten(meditations)
  end

  def chapter_to_markdown(chapter) do
    "### #{chapter.book}-#{chapter.chapter}\n\n#{chapter.text}"
  end

  def book_to_markdown({book, book_index}) do
    book_number = book_index + 1
    "## Book #{book_number}" <> Enum.map_join book, "\n\n\n", &chapter_to_markdown/1
  end

  def meditations_to_markdown(meditations) do
    link = Application.get_env(:marc, :base_url)
    "# Marcus Aurelius - Meditations\n\n\nFrom #{link}\n\n--------\n\n" <> (
      meditations
      |> Enum.with_index()
      |> Enum.map_join("\n\n\n", &book_to_markdown/1)
    ) <> "\n\n--------"
  end


end
