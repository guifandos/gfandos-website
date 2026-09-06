#!/usr/bin/env bash
# Render both language versions into docs/.
# The English render cleans docs/; the Spanish one is added with --no-clean.
# Sitemap and search index are merged so both languages are covered.
set -euo pipefail
cd "$(dirname "$0")"
quarto render
cp docs/sitemap.xml /tmp/sitemap-en.xml
cp docs/search.json /tmp/search-en.json
QUARTO_PROFILE=es quarto render --no-clean
python3 - <<'PY'
import re, json
en=open("/tmp/sitemap-en.xml").read(); es=open("docs/sitemap.xml").read()
urls=re.findall(r"<url>.*?</url>", es, re.S)
open("docs/sitemap.xml","w").write(en.replace("</urlset>", "".join(urls)+"</urlset>"))
sen=json.load(open("/tmp/search-en.json")); ses=json.load(open("docs/search.json"))
json.dump(sen+ses, open("docs/search.json","w"), ensure_ascii=False)
PY
echo "Rendered EN + ES into docs/"
