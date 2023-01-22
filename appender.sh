#!/bin/bash

SETTINGS_FILE=$1
ITEM=$2
CONTENT=$3

findLineNumber() {
  case $(grep -c "$2" "$1") in
    0)
      return 0
      ;;
    1)
      grep -n "$2" "$1" | awk -F ':' '{print $1}'
      return 0
      ;;
    *)
      return 1
  esac
}

lines=$(findLineNumber "$SETTINGS_FILE" "^  <\/$ITEM>$")
$? || exit 1
echo "$?: $lines"

lines=$(findLineNumber "$SETTINGS_FILE" "^<\/settings>$")
$? || exit 1
echo "$?: $lines"

lines=$(findLineNumber "$SETTINGS_FILE" "settings")
$? || exit 1
echo "$?: $lines"

echo 'ok!'
