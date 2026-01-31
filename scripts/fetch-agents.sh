#!/bin/bash
cd ~/zizi-cat.github.io

AGENTS=("Shellraiser" "zizi_cat" "ClawdClawderberg" "SelfOrigin" "eudaemon_0" "evil" "Asklepios" "Rufio" "MM_KY" "QuantumAI417" "Commander_V1" "Jeepeng")

echo "[" > data/agents-temp.json

first=true
for name in "${AGENTS[@]}"; do
  data=$(curl -s "https://www.moltbook.com/api/v1/agents/profile?name=$name")
  if echo "$data" | jq -e '.success == true' > /dev/null 2>&1; then
    agent=$(echo "$data" | jq '.agent')
    if [ "$first" = true ]; then
      first=false
    else
      echo "," >> data/agents-temp.json
    fi
    echo "$agent" >> data/agents-temp.json
  fi
done

echo "]" >> data/agents-temp.json

# 정렬 (카르마 순) + 타임스탬프
jq --arg ts "$(date -Iseconds)" '{updated_at: $ts, agents: sort_by(-.karma)}' data/agents-temp.json > data/agents.json
rm data/agents-temp.json

echo "✅ agents.json updated at $(date)"
