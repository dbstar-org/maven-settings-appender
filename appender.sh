SETTINGS_FILE=$1
ITEM=$2
CONTENT=$3

echo "add to $ITEM use: $CONTENT"
grep -n '$ITEM' $SETTINGS_FILE
echo 'ok!'
