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

git init
git config user.name "SNTL84"
git config user.email "sntl84@desidevloper.com"
git add .
git commit -m "🍽️ Shiv Gujarati Thali — Full Marketing Stack v1.0"
git branch -M main
git remote add origin "https://${GITHUB_TOKEN}@github.com/${GITHUB_USER}/${REPO_NAME}.git" 2>/dev/null || \
  git remote set-url origin "https://${GITHUB_TOKEN}@github.com/${GITHUB_USER}/${REPO_NAME}.git"
git push -u origin main

echo "✅ PUSHED: https://github.com/${GITHUB_USER}/${REPO_NAME}"
python3 docs/update_repo_counter.py
echo "🎉 All done, Milan!"