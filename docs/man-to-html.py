"""mdbook preprocessor that translates the man pages to HTML using groff"""

import json
import sys
import os
import io
import re
import subprocess


man_page_pattern = re.compile('{{\s*#man\s+(.+)\s+}}')


def man_to_html(man_page):
    """convert the input man page into html using groff"""
    result = subprocess.run(
        [ 'groff', '-mandoc', '-Tascii', str(man_page) ],
        capture_output = True,
        text = True,
        check = True
    )
    return '```\n'+result.stdout+'\n```'


def scan_chapter(chapter):
    old_content = io.StringIO(chapter['content'])
    new_content = io.StringIO()
    for line in old_content.readlines():
        m = man_page_pattern.match(line)
        if not m:
            new_content.write(line)
            continue
        new_content.write(man_to_html(*m.groups()))
        new_content.write('\n')

    chapter['content'] = new_content.getvalue()

    for subitem in chapter['sub_items']:
        if 'Chapter' in subitem:
            scan_chapter(subitem['Chapter'])

    return


if __name__ == '__main__':
    if len(sys.argv) > 1: # we check if we received any argument
        if sys.argv[1] == "supports":
            # then we are good to return an exit status code of 0, since the other argument will just be the renderer's name
            sys.exit(0)
        elif sys.argv[1] == 'test':
            pass      

    # load both the context and the book representations from stdin
    context, book = json.load(sys.stdin)
    with open('book.json','w') as f:
        json.dump(book, f, indent=2)
    for section in book['sections']:
        if 'Chapter' in section:
            # content and not a partitioning title
            scan_chapter(section['Chapter'])
    # we are done with the book's modification, we can just print it to stdout,
    print(json.dumps(book))

