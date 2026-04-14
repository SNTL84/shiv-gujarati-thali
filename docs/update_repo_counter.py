#!/usr/bin/env python3
"""
SNTL84 Repo Counter Updater
============================
Updates https://github.com/SNTL84/sntl84-repo-counter with
accurate public + private repo counts using GitHub API.

Usage:
export GITHUB_TOKEN=ghp_your_token_here
python3 update_counter.py

Built by SNTL84 · Milan · desidevloper.com
"""

import os
import json
import base64
import urllib.request
import urllib.error
from datetime import datetime, timezone

GITHUB_USER = "SNTL84"
REPO_TARGET = "sntl84-repo-counter"
TOKEN = os.environ.get("GITHUB_TOKEN", "")

def github_get(path):
    url = f"https://api.github.com{path}"
    req = urllib.request.Request(url, headers={
        "Authorization": f"token {TOKEN}",
        "Accept": "application/vnd.github.v3+json",
        "User-Agent": "SNTL84-counter-bot"
    })
    with urllib.request.urlopen(req) as resp:
        return json.loads(resp.read())

def github_put(path, data):
    url = f"https://api.github.com{path}"
    payload = json.dumps(data).encode()
    req = urllib.request.Request(url, data=payload, method="PUT", headers={
        "Authorization": f"token {TOKEN}",
        "Accept": "application/vnd.github.v3+json",
        "Content-Type": "application/json",
        "User-Agent": "SNTL84-counter-bot"
    })
    with urllib.request.urlopen(req) as resp:
        return json.loads(resp.read())

def get_all_repos():
    """Fetch ALL repos (public + private) with pagination."""
    repos = []
    page = 1
    while True:
        batch = github_get(f"/user/repos?per_page=100&page={page}&type=all")
        if not batch:
            break
        repos.extend(batch)
        if len(batch) < 100:
            break
        page += 1
    return repos

def main():
    if not TOKEN:
        print("Set GITHUB_TOKEN environment variable first.")
        return

    print(f"Fetching all repos for @{GITHUB_USER}...")
    repos = get_all_repos()

    public_repos = [r for r in repos if not r["private"]]
    private_repos = [r for r in repos if r["private"]]
    total = len(repos)
    now = datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M UTC")

    print(f"Public: {len(public_repos)}")
    print(f"Private: {len(private_repos)}")
    print(f"Total: {total}")

    readme_content = f"""# SNTL84 Repo Counter

> Auto-updated · Last sync: **{now}**

## Repository Stats — @SNTL84

| Type | Count |
|------|-------|
| Public Repos | **{len(public_repos)}** |
| Private Repos | **{len(private_repos)}** |
| **Total** | **{total}** |

---

### Public Repositories

| # | Repo | Description |
|---|------|-------------|
""" + "".join(
        f"| {i+1} | [{r['name']}]({r['html_url']}) | {r.get('description') or '-'} |\n"
        for i, r in enumerate(sorted(public_repos, key=lambda x: x['updated_at'], reverse=True))
    ) + """
---

Powered by SNTL84 · Milan · AI Workflow Developer · Surat
"""

    try:
        current = github_get(f"/repos/{GITHUB_USER}/{REPO_TARGET}/contents/README.md")
        sha = current["sha"]
    except Exception:
        sha = None

    payload = {
        "message": f"Auto-update: {len(public_repos)} public, {len(private_repos)} private, {total} total [{now}]",
        "content": base64.b64encode(readme_content.encode()).decode(),
        "committer": {
            "name": "SNTL84 Bot",
            "email": "sntl84@desidevloper.com"
        }
    }
    if sha:
        payload["sha"] = sha

    result = github_put(
        f"/repos/{GITHUB_USER}/{REPO_TARGET}/contents/README.md",
        payload
    )
    print(f"Updated: {result['content']['html_url']}")

if __name__ == "__main__":
    main()
