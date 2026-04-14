#!/bin/bash
# ============================================================
# SNTL84 — Shiv Gujarati Thali — GitHub Push Script
# Run this ONCE on your local machine to push everything.
# Built by SNTL84 · Milan · desidevloper.com
# ============================================================

set -e

GITHUB_USER="SNTL84"
REPO_NAME="shiv-gujarati-thali"
GITHUB_TOKEN="${GITHUB_TOKEN:-}" # set via: export GITHUB_TOKEN=ghp_xxx

echo "🍽️ SNTL84 — Shiv Gujarati Thali Deploy"
echo "=========================================="

# --- 1. Create repo on GitHub if it doesn't exist ---
if [ -n "$GITHUB_TOKEN" ]; then
  echo "📦 Creating/checking GitHub repo..."
  curl -s -X POST \
    -H "Authorization: token $GITHUB_TOKEN" \
    -H "Accept: application/vnd.github.v3+json" \
    https://api.github.com/user/repos \
    -d "{
      \"name\": \"$REPO_NAME\",
      \"description\": \"🍽️ Shiv Gujarati Unlimited Thali — Surat | Full digital presence built by SNTL84\",
      \"homepage\": \"https://desidevloper.com\",
      \"private\": false,
      \"has_issues\": true,
      \"has_projects\": false,
      \"has_wiki\": false
    }" > /dev/null && echo "✅ Repo ready."
fi

# --- 2. Init git ---
git init
git config user.name "SNTL84"
git config user.email "sntl84@desidevloper.com"

# --- 3. Stage all files ---
git add .

# --- 4. Commit ---
git commit -m "🍽️ Shiv Gujarati Thali — Full Marketing Stack v1.0

Built by SNTL84 · Milan · AI Workflow Developer · Surat, India
🌐 https://desidevloper.com | 💬 wa.me/919727413309
🔗 linkedin.com/in/sntl2784 | 💻 github.com/SNTL84

#SNTL84 #AIWorkflow #DesignedInSurat #GujaratiThali"

# --- 5. Push ---
git branch -M main
git remote add origin "https://${GITHUB_TOKEN}@github.com/${GITHUB_USER}/${REPO_NAME}.git" 2>/dev/null || \
  git remote set-url origin "https://${GITHUB_TOKEN}@github.com/${GITHUB_USER}/${REPO_NAME}.git"

git push -u origin main

echo ""
echo "✅ PUSHED: https://github.com/${GITHUB_USER}/${REPO_NAME}"
echo ""
echo "🎉 All done, Milan!"
echo "  Landing page: https://${GITHUB_USER}.github.io/${REPO_NAME}/"
echo "  Repo counter: https://github.com/${GITHUB_USER}/sntl84-repo-counter"
