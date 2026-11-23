import os
import json
import time
import shutil
import zipfile
import subprocess
import requests
from pathlib import Path

TOKEN = os.environ["ZENODO_ACCESS_TOKEN"]
BASE_URL = "https://zenodo.org/api/records"
HEADERS_JSON = {
    "Authorization": f"Bearer {TOKEN}",
    "Content-Type": "application/json",
    "Accept": "application/vnd.inveniordm.v1+json",
}
HEADERS_OCTET = {
    "Authorization": f"Bearer {TOKEN}",
    "Content-Type": "application/octet-stream",
}

APACHE_LICENSE = open("/workspace/NS_Millennium_Proof/LICENSE", "r", encoding="utf-8").read()
assert "Copyright 2026 Benjamin Stanley Frohman" in APACHE_LICENSE

with open("/workspace/zenodo_batch_17_reserved.json", "r", encoding="utf-8") as f:
    BATCH = json.load(f)

def make_notice(repo_name: str, title: str, doi: str, origin_prov: str) -> str:
    return f"""{repo_name} — {title}
Copyright 2026 Benjamin Stanley Frohman
ORCID: https://orcid.org/0009-0006-7068-3718
GitHub: https://github.com/BenFrohman/{repo_name}
Zenodo DOI: https://doi.org/{doi}
Origin Provenance: {origin_prov}

This product includes software, formal Lean 4 proofs, and mathematical manuscripts developed by
Benjamin Stanley Frohman (frohmanbenjamin@gmail.com).

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this work except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0
"""

def make_citation_cff(repo_name: str, title: str, doi: str, pub_date: str) -> str:
    safe_title = title.replace('"', '\\"')
    return f"""cff-version: 1.2.0
message: "If you use this work, please cite it using the metadata below."
title: "{safe_title}"
authors:
  - family-names: "Frohman"
    given-names: "Benjamin Stanley"
    orcid: "https://orcid.org/0009-0006-7068-3718"
    email: "frohmanbenjamin@gmail.com"
version: "1.0.0"
doi: "{doi}"
date-released: "{pub_date}"
license: "Apache-2.0"
repository-code: "https://github.com/BenFrohman/{repo_name}"
url: "https://doi.org/{doi}"
"""

def make_zenodo_json(repo_name: str, title: str, doi: str, pub_date: str, description_html: str, keywords: list, origin_prov: str) -> str:
    data = {
        "title": title,
        "upload_type": "publication",
        "publication_type": "preprint",
        "publication_date": pub_date,
        "version": "1.0.0",
        "license": "Apache-2.0",
        "doi": doi,
        "creators": [
            {
                "name": "Frohman, Benjamin Stanley",
                "affiliation": "Independent Researcher",
                "orcid": "0009-0006-7068-3718"
            }
        ],
        "keywords": keywords,
        "related_identifiers": [
            {
                "identifier": f"https://github.com/BenFrohman/{repo_name}",
                "relation": "isSupplementTo",
                "scheme": "url"
            }
        ],
        "notes": f"Origin Provenance: {origin_prov}. Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved. Licensed under the Apache License, Version 2.0 (http://www.apache.org/licenses/LICENSE-2.0).",
        "description": description_html
    }
    return json.dumps(data, indent=2) + "\n"

def make_new_repo_readme(item: dict) -> str:
    repo_name = item["repo_name"]
    title = item["title"]
    doi = item["doi"]
    rec_id = item["id"]
    origin_prov = item["origin_provenance"]
    pub_date = item["pub_date"]
    main_pdf_name = os.path.basename(item["main_pdf"])
    extra_lines = ""
    for ef in item["extra_files"]:
        ef_name = os.path.basename(ef)
        extra_lines += f"- [`{ef_name}`](./{ef_name})\n"

    return f"""# {title}

[![DOI](https://zenodo.org/badge/DOI/{doi}.svg)](https://doi.org/{doi})
[![License: Apache-2.0](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![ORCID](https://img.shields.io/badge/ORCID-0009--0006--7068--3718-brightgreen.svg)](https://orcid.org/0009-0006-7068-3718)

**Author:** Benjamin Stanley Frohman ([ORCID: 0009-0006-7068-3718](https://orcid.org/0009-0006-7068-3718))  
**Origin Provenance Date:** `{origin_prov}`  
**Publication Date:** `{pub_date}`  
**Zenodo DOI:** [`{doi}`](https://doi.org/{doi}) ([Zenodo Record `{rec_id}`](https://zenodo.org/records/{rec_id}))  
**License:** Apache License, Version 2.0 (`Copyright (c) 2026 Benjamin Stanley Frohman`)

---

## Primary Manuscript & Artifacts

- **Primary Typeset Paper (PDF):** [`{main_pdf_name}`](./{main_pdf_name})
{extra_lines}- **Citation Metadata:** [`CITATION.cff`](./CITATION.cff) | [`.zenodo.json`](./.zenodo.json)
- **License & Notice:** [`LICENSE`](./LICENSE) | [`NOTICE`](./NOTICE)

---

## Abstract & Summary

{item["description_html"].replace("<p>", "").replace("</p>", "\n\n").replace("<code>", "`").replace("</code>", "`").replace("<strong>", "**").replace("</strong>", "**").replace("<em>", "*").replace("</em>", "*").replace("&rarr;", "->").replace("&rArr;", "=>").replace("&ge;", ">=").replace("&le;", "<=").replace("&infin;", "infinity").replace("&preceq;", "<=").replace("&ldquo;", '"').replace("&rdquo;", '"').replace("&ndash;", "-").replace("&amp;", "&").strip()}

---

## Citation

```bibtex
@misc{{frohman2026_{repo_name.replace("-", "_")},
  author       = {{Frohman, Benjamin Stanley}},
  title        = {{{title}}},
  year         = {{2026}},
  month        = {{{pub_date[5:7]}}},
  publisher    = {{Zenodo}},
  version      = {{1.0.0}},
  doi          = {{{doi}}},
  url          = {{https://doi.org/{doi}}}
}}
```

---

## License & Copyright

Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.  
Licensed under the Apache License, Version 2.0 (see [`LICENSE`](./LICENSE) and [`NOTICE`](./NOTICE)).
"""

def update_existing_repo_readme(readme_path: Path, item: dict):
    doi = item["doi"]
    rec_id = item["id"]
    origin_prov = item["origin_provenance"]
    main_pdf_rel = os.path.relpath(item["main_pdf"], item["repo_dir"])
    header_block = f"""<!-- ZENODO-PROVENANCE-HEADER -->
[![DOI](https://zenodo.org/badge/DOI/{doi}.svg)](https://doi.org/{doi})
[![License: Apache-2.0](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![ORCID](https://img.shields.io/badge/ORCID-0009--0006--7068--3718-brightgreen.svg)](https://orcid.org/0009-0006-7068-3718)

> **Author:** Benjamin Stanley Frohman ([ORCID: 0009-0006-7068-3718](https://orcid.org/0009-0006-7068-3718))  
> **Origin Provenance:** `{origin_prov}`  
> **Zenodo Archive & DOI:** [`{doi}`](https://doi.org/{doi}) ([Zenodo Record `{rec_id}`](https://zenodo.org/records/{rec_id}))  
> **Primary Manuscript PDF:** [`{main_pdf_rel}`](./{main_pdf_rel})  
> **Copyright & License:** Copyright (c) 2026 Benjamin Stanley Frohman. Licensed under the Apache License, Version 2.0 ([`LICENSE`](./LICENSE), [`NOTICE`](./NOTICE)).
<!-- /ZENODO-PROVENANCE-HEADER -->
"""
    if readme_path.exists():
        content = readme_path.read_text(encoding="utf-8")
        if "<!-- ZENODO-PROVENANCE-HEADER -->" in content:
            start = content.index("<!-- ZENODO-PROVENANCE-HEADER -->")
            end = content.index("<!-- /ZENODO-PROVENANCE-HEADER -->") + len("<!-- /ZENODO-PROVENANCE-HEADER -->")
            content = content[:start] + header_block + content[end:]
        else:
            lines = content.splitlines()
            if lines and lines[0].startswith("#"):
                content = lines[0] + "\n\n" + header_block + "\n" + "\n".join(lines[1:]) + "\n"
            else:
                content = header_block + "\n" + content
        readme_path.write_text(content, encoding="utf-8")
    else:
        readme_path.write_text(make_new_repo_readme(item), encoding="utf-8")

def create_repo_zip(repo_dir: str, zip_path: str):
    repo_path = Path(repo_dir)
    with zipfile.ZipFile(zip_path, "w", zipfile.ZIP_DEFLATED) as zf:
        for root, dirs, files in os.walk(repo_path):
            dirs[:] = [d for d in dirs if d not in (".git", ".lake", "build", "__pycache__", "node_modules")]
            for file in sorted(files):
                if file.endswith(".zip") or file.startswith(".DS_Store"):
                    continue
                full_p = Path(root) / file
                rel_p = full_p.relative_to(repo_path)
                zf.write(full_p, arcname=str(Path(repo_path.name) / rel_p))

def upload_file_to_invenio_draft(rec_id: int, file_path: str):
    fname = os.path.basename(file_path)
    # 1. Initialize file entry
    r_init = requests.post(
        f"{BASE_URL}/{rec_id}/draft/files",
        headers=HEADERS_JSON,
        json=[{"key": fname}]
    )
    if r_init.status_code not in (200, 201):
        raise RuntimeError(f"Init file {fname} on {rec_id} failed: {r_init.status_code} {r_init.text}")
    # 2. Upload content
    with open(file_path, "rb") as f:
        r_put = requests.put(
            f"{BASE_URL}/{rec_id}/draft/files/{fname}/content",
            headers=HEADERS_OCTET,
            data=f
        )
    if r_put.status_code not in (200, 201):
        raise RuntimeError(f"Put file {fname} on {rec_id} failed: {r_put.status_code} {r_put.text}")
    # 3. Commit file
    r_commit = requests.post(
        f"{BASE_URL}/{rec_id}/draft/files/{fname}/commit",
        headers=HEADERS_JSON
    )
    if r_commit.status_code not in (200, 201):
        raise RuntimeError(f"Commit file {fname} on {rec_id} failed: {r_commit.status_code} {r_commit.text}")

def set_default_preview(rec_id: int, default_pdf_name: str):
    r_get = requests.get(f"{BASE_URL}/{rec_id}/draft", headers=HEADERS_JSON)
    r_get.raise_for_status()
    draft = r_get.json()
    payload = {
        "access": draft.get("access", {"record": "public", "files": "public"}),
        "files": {
            "enabled": True,
            "default_preview": default_pdf_name
        },
        "metadata": draft["metadata"]
    }
    r_put = requests.put(f"{BASE_URL}/{rec_id}/draft", headers=HEADERS_JSON, json=payload)
    if r_put.status_code not in (200, 201):
        raise RuntimeError(f"Set default_preview on {rec_id} failed: {r_put.status_code} {r_put.text}")

os.makedirs("/workspace/zenodo_zips_17", exist_ok=True)

# Special handling for frohmanian-tether-manuscript-2026-06-01: copy the companion PDFs into its companion_papers/ folder so the repo and zip carry all 5 timestamped companion papers!
ft_comp_dir = Path("/workspace/repos_audit/frohmanian-tether-manuscript-2026-06-01/companion_papers")
ft_comp_dir.mkdir(parents=True, exist_ok=True)
for extra_src in BATCH["frohmanian-tether-manuscript-2026-06-01"]["extra_files"]:
    dst = ft_comp_dir / os.path.basename(extra_src)
    shutil.copy2(extra_src, dst)

for key, item in BATCH.items():
    repo_dir = Path(item["repo_dir"])
    repo_name = item["repo_name"]
    doi = item["doi"]
    rec_id = item["id"]
    title = item["title"]
    pub_date = item["pub_date"]
    origin_prov = item["origin_provenance"]

    # Write LICENSE, NOTICE, CITATION.cff, .zenodo.json
    (repo_dir / "LICENSE").write_text(APACHE_LICENSE, encoding="utf-8")
    (repo_dir / "NOTICE").write_text(make_notice(repo_name, title, doi, origin_prov), encoding="utf-8")
    (repo_dir / "CITATION.cff").write_text(make_citation_cff(repo_name, title, doi, pub_date), encoding="utf-8")
    (repo_dir / ".zenodo.json").write_text(
        make_zenodo_json(repo_name, title, doi, pub_date, item["description_html"], item["keywords"], origin_prov),
        encoding="utf-8"
    )

    if item["is_new_repo"]:
        (repo_dir / "README.md").write_text(make_new_repo_readme(item), encoding="utf-8")
    else:
        update_existing_repo_readme(repo_dir / "README.md", item)

    # Build zip archive of repository
    zip_path = f"/workspace/zenodo_zips_17/{repo_name}-v1.0.0.zip"
    create_repo_zip(str(repo_dir), zip_path)

    # Upload main PDF, extra files, and repo zip to Zenodo draft
    main_pdf = item["main_pdf"]
    upload_file_to_invenio_draft(rec_id, main_pdf)
    uploaded_names = {os.path.basename(main_pdf)}

    for ef in item["extra_files"]:
        ef_name = os.path.basename(ef)
        if ef_name not in uploaded_names and os.path.exists(ef):
            upload_file_to_invenio_draft(rec_id, ef)
            uploaded_names.add(ef_name)

    upload_file_to_invenio_draft(rec_id, zip_path)
    set_default_preview(rec_id, os.path.basename(main_pdf))
    print(f"[UPLOADED & PREVIEW SET] {repo_name} -> https://zenodo.org/uploads/{rec_id} ({doi}) | files: {len(uploaded_names)+1}")

print("\nAll 17 Zenodo records populated with PDFs, ZIP archives, default_preview, and copyright metadata!")
