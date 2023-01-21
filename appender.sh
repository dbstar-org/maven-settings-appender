SETTINGS_FILE=$1
ITEM=$2
CONTENT=$3

echo "add to $ITEM use: $CONTENT"
echo grep -n "^<\/settings>$" "$SETTINGS_FILE"
grep -n "^<\/settings>$" "$SETTINGS_FILE"
echo grep -n "^  <\/$ITEM>$" "$SETTINGS_FILE"
grep -n "^  <\/$ITEM>$" "$SETTINGS_FILE"
echo 'ok!'
