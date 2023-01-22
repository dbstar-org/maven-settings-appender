#!/bin/bash

SETTINGS_FILE=$1
ITEM=$2
CONTENT=$3

findLineNumber() {
  echo grep -n "$2" "$1"
  grep -n "$2" "$1"
}

echo "add to $ITEM use: $CONTENT"
findLineNumber "$SETTINGS_FILE" "^<\/settings>$"
findLineNumber "$SETTINGS_FILE" "^  <\/$ITEM>$"
echo 'ok!'
