#!/bin/bash

LINES=10
ORDER="up"

while [[ $# -gt 0 ]]; do
  case $1 in
    -l|--lines) LINES="$2"; shift 2 ;;
    -o|--order) ORDER="$2"; shift 2 ;;
    *) DIR="$1"; shift ;;
  esac
done

if [[ -z "$DIR" ]]; then
  echo "Usage: $0 [OPTIONS] DIR"
  exit 1
fi

if [[ ! -d "$DIR" ]]; then
  echo "Directory '$DIR' does not exist"
  exit 1
fi

LOG_REGEX='^\[ (INFO|DEBUG|WARNING|ERROR) \][[:space:]]+[0-9]{2}:[0-9]{2}:[0-9]{4}[[:space:]]+(0|[1-9][0-9]*)[[:space:]]+[A-Za-z0-9 _-]+$'

find "$DIR" -type f -name "*.log" -print0 | xargs -0 cat | grep -E "$LOG_REGEX" | sort -k5,5nr |
  { [[ "$ORDER" == "up" ]] && head -n "$LINES" || tail -n "$LINES"; }
