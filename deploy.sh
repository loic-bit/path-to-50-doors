#!/usr/bin/env bash
# Deploy path-to-50-doors to Railway (investingsection8-50-doors)
# Usage: ./deploy.sh "optional commit message"

set -e

ENV_FILE="$(cd "$(dirname "$0")/../../.." && pwd)/CTRL/.env"
if [ ! -f "$ENV_FILE" ]; then
  echo "ERROR: CTRL/.env not found at $ENV_FILE"
  exit 1
fi
GITHUB_TOKEN=$(grep '^GITHUB_TOKEN=' "$ENV_FILE" | cut -d '=' -f2-)
RAILWAY_TOKEN=$(grep '^RAILWAY_TOKEN=' "$ENV_FILE" | cut -d '=' -f2-)

if [ -z "$GITHUB_TOKEN" ] || [ -z "$RAILWAY_TOKEN" ]; then
  echo "ERROR: GITHUB_TOKEN or RAILWAY_TOKEN missing in CTRL/.env"
  exit 1
fi

COMMIT_MSG="${1:-update calculator}"

git add index.html
git diff --cached --quiet && echo "Nothing to commit." && exit 0
git commit -m "$COMMIT_MSG"
git push "https://${GITHUB_TOKEN}@github.com/loic-bit/path-to-50-doors.git" main

# Trigger Railway redeploy
curl -s -X POST https://backboard.railway.app/graphql/v2 \
  -H "Authorization: Bearer $RAILWAY_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"query":"mutation{serviceInstanceDeploy(serviceId:\"87572e46-0621-466f-9b2c-544ba04beafe\",environmentId:\"57c93bc4-7ce9-4df2-831f-456bc1e0e6b6\")}"}' > /dev/null

echo ""
echo "Deployed. Live at: https://investingsection8-50-doors-production.up.railway.app/"
echo "(Usually live within 60 seconds.)"
