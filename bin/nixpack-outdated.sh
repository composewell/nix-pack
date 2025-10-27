#!/usr/bin/env bash
set -euo pipefail

CSV_FILE="$1"

if [ ! -f "$CSV_FILE" ]; then
  echo "Usage: $0 path/to/sources.csv"
  exit 1
fi

while IFS=, read -r name owner repo branch rev; do
  # skip header or empty lines
  [ -z "$name" ] && continue
  [[ "$name" == "name" ]] && continue

  remote_rev=$(git ls-remote "git@github.com:${owner}/${repo}" "refs/heads/${branch}" | cut -f1)

  if [ -z "$remote_rev" ]; then
    echo "Warning: could not fetch branch $branch for $owner/$repo"
    continue
  fi

  if [ "$remote_rev" != "$rev" ]; then
    echo "$name: https://github.com/${owner}/${repo}/commits/${branch} $remote_rev"
  fi
done < "$CSV_FILE"
