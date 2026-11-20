#!/usr/bin/env bash
# Routes Claude Code in this Sprite through Apiary's switch proxy, as a device of its own.
# sprite-profiles runs it at launch, after the checkpoint, so the device's token is never
# saved in a checkpoint. Nothing here reads, prints or stores a credential: `apiary enrol`
# keeps the token in ~/.apiary (0600) and never prints it.
set -euo pipefail

site="https://apiary.wtf"
apiary="$HOME/.local/bin/apiary"
device="sprite-$(uname -n)"

for t in curl jq; do
  command -v "$t" >/dev/null || { sudo apt-get -qq update && sudo apt-get -qq install -y "$t" >/dev/null; }
done

echo "Installing the Apiary client from $site"
curl -fsSL "$site/install/apiary" | bash >/dev/null

"$apiary" setup >/dev/null
# Fly's connector gateway stays direct, so the gateway sees this Sprite, not the proxy.
"$apiary" config no-proxy api.sprites.dev >/dev/null

"$apiary" enrol --name "$device"
# doctor's report names the Apiary member and its accounts: print it only when it fails.
report="$(mktemp)"
if "$apiary" doctor >"$report" 2>&1; then
  echo "apiary doctor: ok"
  rm -f "$report"
else
  cat "$report"; rm -f "$report"
  exit 1
fi
