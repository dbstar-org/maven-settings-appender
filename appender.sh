#!/bin/bash

SETTINGS_FILE=$1
ITEM=$2
CONTENT=$3

findLineNumber() {
  echo grep -n "$2" "$1"
  lines=$(grep -c "$2" "$1")
  echo $lines
  if [ $lines -eq 0 ]; then
    return 0
  elif [ $lines -ne 1 ]; then
    return -1
  else
    return $(grep -n "$2" "$1" | awk -F ':' '{print $1}')
  fi
}

echo "add to $ITEM use: $CONTENT"
findLineNumber "$SETTINGS_FILE" "^<\/settings>$"
echo $?
findLineNumber "$SETTINGS_FILE" "^  <\/$ITEM>$"
echo $?
findLineNumber "$SETTINGS_FILE" "settings>"
echo $?
echo 'ok!'
