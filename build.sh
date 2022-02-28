#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"

KEYFILE="$HOME/connectiq/developer_key"
DEVICE=fr55

echo "build"
monkeyc -f monkey.jungle -r -d $DEVICE -y $KEYFILE -o bin/saturnface.prg

echo "ok"

if [[ -n $1 ]]; then
    echo "opening simulator"
    monkeydo bin/saturnface.prg $DEVICE
fi
