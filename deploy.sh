#!/usr/bin/env bash
# Deploy path-to-50-doors to GitHub Pages
# Usage: ./deploy.sh "optional commit message"

set -e

# Load GitHub token from CTRL env
ENV_FILE="$(cd "$(dirname "$0")/../../.." && pwd)/CTRL/.env"
if [ ! -f "$ENV_FILE" ]; then
  echo "ERROR: CTRL/.env not found at $ENV_FILE"
  exit 1
fi
GITHUB_TOKEN=$(grep '^GITHUB_TOKEN=' "$ENV_FILE" | cut -d '=' -f2-)

if [ -z "$GITHUB_TOKEN" ]; then
  echo "ERROR: GITHUB_TOKEN not set in CTRL/.env"
  exit 1
fi

COMMIT_MSG="${1:-update calculator}"

git add index.html
git diff --cached --quiet && echo "Nothing to commit." && exit 0
git commit -m "$COMMIT_MSG"
git push "https://${GITHUB_TOKEN}@github.com/loic-bit/path-to-50-doors.git" main

echo ""
echo "Deployed. Live at: https://loic-bit.github.io/path-to-50-doors/"
echo "(GitHub Pages usually updates within 60 seconds.)"
