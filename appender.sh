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
      echo "find more then one [$2] in $1" >&2
      return 1
  esac
}

NEW_SETTINGS_FILE=${SETTINGS_FILE}-$(echo $RANDOM)
echo "create new temp settings.xml file: $NEW_SETTINGS_FILE"

lines=$(findLineNumber "$SETTINGS_FILE" "^  <\/$ITEM>$") || exit 1
if [ -z "$lines" ]; then
  echo "[</$ITEM>] not exist in $SETTINGS_FILE, created."

  lines=$(findLineNumber "$SETTINGS_FILE" "^<\/settings>$") || exit 1
  if [ -z "$lines" ]; then
    echo "[</settings>] not found in $SETTINGS_FILE, exited with error."
    exit 2
  fi
  echo "find [</settings>] at [$lines] line in $SETTINGS_FILE."
  echo "copy top $(expr "$lines" - 1) lines of $SETTINGS_FILE to $NEW_SETTINGS_FILE."
  head -n $(expr "$lines" - 1) $SETTINGS_FILE >$NEW_SETTINGS_FILE
  echo "append <$ITEM> to $NEW_SETTINGS_FILE."
  echo "  <$ITEM>" >>$NEW_SETTINGS_FILE
  echo "append content to $NEW_SETTINGS_FILE."
  echo "$CONTENT" | awk '{print "    "$0}' >>$NEW_SETTINGS_FILE
  echo "append </$ITEM> to $NEW_SETTINGS_FILE."
  echo "  </$ITEM>" >>$NEW_SETTINGS_FILE
  echo "copy remaining lines from $lines line of $SETTINGS_FILE to $NEW_SETTINGS_FILE."
  tail -n +$lines $SETTINGS_FILE >>$NEW_SETTINGS_FILE
else
  echo "find [</$ITEM>] at [$lines] line in $SETTINGS_FILE."
  echo "copy top $(expr "$lines" - 1) lines of $SETTINGS_FILE to $NEW_SETTINGS_FILE."
  head -n $(expr "$lines" - 1) $SETTINGS_FILE >$NEW_SETTINGS_FILE
  echo "append content to $NEW_SETTINGS_FILE."
  echo "$CONTENT" | awk '{print "    "$0}' >>$NEW_SETTINGS_FILE
  echo "copy remaining lines from $lines line of $SETTINGS_FILE to $NEW_SETTINGS_FILE."
  tail -n +$lines $SETTINGS_FILE >>$NEW_SETTINGS_FILE
fi

echo "overwrite $SETTINGS_FILE with $NEW_SETTINGS_FILE"
cp -f "$NEW_SETTINGS_FILE" "$SETTINGS_FILE"
echo "delete temp settings.xml file: $NEW_SETTINGS_FILE"
rm -f "$NEW_SETTINGS_FILE"
