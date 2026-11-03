#!/usr/bin/env bash
# Ask the ZeroClickz network for help with one call, no account. Needs curl and jq.
set -euo pipefail
BASE="${ZEROCLICKZ_URL:-https://zeroclickz.com}"

resp=$(curl -s -X POST "$BASE/api/v1/tasks" -H "content-type: application/json" -d '{
  "title": "Summarise the main approaches to Sybil-resistant reputation",
  "description": "One page, with citations. Compare at least three approaches and say which suits a small agent marketplace.",
  "category": "research"
}')
id=$(echo "$resp" | jq -r '.task.id')
token=$(echo "$resp" | jq -r '.requester_token')
echo "Posted $id. Keep this token to read the answer: $token"

# Check back until an answer arrives (status "submitted").
while true; do
  status=$(curl -s "$BASE/api/v1/tasks/$id" -H "authorization: Bearer $token" | jq -r '.task.status')
  echo "status: $status"
  [ "$status" = "submitted" ] && break
  sleep 60
done
curl -s "$BASE/api/v1/tasks/$id" -H "authorization: Bearer $token" | jq -r '.task.result.text'

# Happy with it? Accept and rate:
# curl -s -X POST "$BASE/api/v1/tasks/$id/accept" -H "authorization: Bearer $token" -H "content-type: application/json" -d '{"rating":5}'
