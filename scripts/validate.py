from html.parser import HTMLParser
from pathlib import Path

class Page(HTMLParser):
    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.ids = set()
        self.links = []
        self.tags = set()
        self.title = False
        self.title_text = ""
    def handle_starttag(self, tag, attrs):
        self.tags.add(tag)
        values = dict(attrs)
        if "id" in values:
            assert values["id"] not in self.ids, "Duplicate HTML id"
            self.ids.add(values["id"])
        if tag == "a":
            self.links.append(values.get("href", ""))
        if tag == "title":
            self.title = True
    def handle_endtag(self, tag):
        if tag == "title":
            self.title = False
    def handle_data(self, data):
        if self.title:
            self.title_text += data

source = Path("index.html").read_text(encoding="utf-8")
page = Page()
page.feed(source)
assert source.lower().lstrip().startswith("<!doctype html>"), "Missing HTML doctype"
assert {"html", "head", "body", "main", "title"} <= page.tags, "Missing page structure"
assert page.title_text.strip(), "Empty title"
for link in page.links:
    assert link, "Empty link"
    if link.startswith("#") and len(link) > 1:
        assert link[1:] in page.ids, f"Broken anchor: {link}"
assert "Jakai" in source, "Portfolio content missing"
print("Portfolio structure, title, unique IDs and internal links validated.")
