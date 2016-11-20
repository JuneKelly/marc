#! /usr/bin/env python3

import re
import json


# input
MEDITATIONS_TEXT_PATH = "./resources/meditations.txt"


# output
MEDITATIONS_JSON_PATH = "./resources/meditations.json"
MEDITATIONS_FLAT_JSON_PATH = "./resources/meditations_flat.json"
MEDITATIONS_MARKDOWN_PATH = "./resources/meditations.md"


def main():
    print(">> Reading source text")
    source_text = open(MEDITATIONS_TEXT_PATH, 'r').read()
    source_text = re.sub("%%.*$", "", source_text, flags=re.MULTILINE)

    print(">> splitting into books")
    books = re.split(
        "^########  BOOK \w+  ########",
        source_text.strip(),
        flags=re.MULTILINE
    )[1:]

    result = []

    print(">> splitting into chapters")
    for book_idx, book in enumerate(books):
        chapter_list = []
        chapters = re.split("--------", book, flags=re.MULTILINE)
        for chapter_idx, chapter in enumerate(chapters):
            chapter_list.append({
                'book':     book_idx + 1,
                'chapter':  chapter_idx + 1,
                'text':     chapter.strip()
            })
        result.append(chapter_list)

    print(">> Counts:")
    for i, c in enumerate(result):
        print("  Book {}, chapters: {}".format(i+1, len(c)))

    print(">> writing to output files")
    json_data = json.dumps(result, indent=2, sort_keys=True)
    with open(MEDITATIONS_JSON_PATH, 'w') as outfile:
        outfile.write(json_data)

    flattened = []
    for r in result:
        flattened.extend(r)
    flattened_json_data = json.dumps(flattened, indent=2, sort_keys=True)
    with open(MEDITATIONS_FLAT_JSON_PATH, 'w') as outfile:
        outfile.write(flattened_json_data)

    markdown = """# Meditations - Marcus Aurelius\n\n\n"""

    for i, book in enumerate(result):
        markdown = markdown + "\n## Book {}\n\n".format(i+1)
        for j, chapter in enumerate(book):
            markdown = markdown + "\n### {}\n\n{}\n\n\n".format(j+1, chapter['text'])

    with open(MEDITATIONS_MARKDOWN_PATH, 'w') as outfile:
        outfile.write(markdown)


if __name__ == '__main__':
    main()
