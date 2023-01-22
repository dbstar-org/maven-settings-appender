#!/bin/bash

SETTINGS_FILE=$1
SETTINGS_PATH=$(dirname "$SETTINGS_FILE")
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
echo "new settings.xml is $NEW_SETTINGS_FILE"

lines=$(findLineNumber "$SETTINGS_FILE" "^  <\/$ITEM>$") || exit 1
if [ '' == '$lines' ]; then
  echo "[<$ITEM>] not exist in $SETTINGS_FILE, created."

  lines=$(findLineNumber "$SETTINGS_FILE" "^<\/settings>$") || exit 1
  if [ '' == '$lines' ]; then
    echo "[<settings>] not found in $SETTINGS_FILE, exited."
    exit 2
  fi
  echo "find [<settings>] at [$lines] lines in $SETTINGS_FILE."
  head -n $(expr "$lines" - 1) $SETTINGS_FILE >$NEW_SETTINGS_FILE
  echo "  <$ITEM>" >>$NEW_SETTINGS_FILE
  echo "$CONTENT" >>$NEW_SETTINGS_FILE
  echo "  <\/$ITEM>" >>$NEW_SETTINGS_FILE
  tail -n $(expr `wc -l $SETTINGS_FILE | awk '{print $1}'` - "$lines") $SETTINGS_FILE >>$NEW_SETTINGS_FILE
else
  echo "find [<$ITEM>] at [$lines] lines in $SETTINGS_FILE."
  head -n $(expr "$lines" - 1) $SETTINGS_FILE >$NEW_SETTINGS_FILE
  echo "$CONTENT" >>$NEW_SETTINGS_FILE
  tail -n $(expr `wc -l $SETTINGS_FILE | awk '{print $1}'` - "$lines") $SETTINGS_FILE >>$NEW_SETTINGS_FILE
fi

cat "$NEW_SETTINGS_FILE"
