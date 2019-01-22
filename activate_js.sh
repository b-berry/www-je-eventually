#/bin/bash

DEFAULT_JSFILE='assets/js/main.js'
DEFAULT_SEARCH_ID='replace_access_token'
DEFAULT_SEARCH_KEY='replace_access_key'

function usage() {
  echo "Usage: $0 credfile.json"
  exit 1
}  

function is_file() {
  for file in $@; do
    if [ ! -e $1 ]; then
      echo "Error: File not found $1"
      exit 2
    fi
  done
}

function is_installed() {
  status=$(command -v $1)
  if [ -z $status ]; then
    echo "Error: Dependency not met: $1"
    exit 1
  fi
}

# Conditional Tests
if [ $# -lt 1 ]; then usage; fi
is_file $1 $DEFAULT_JSFILE
is_installed 'jq'

# Collect creds
access_key=$(jq -r '.[].access_key?' $1)
list_id=$(jq -r '.[].list_id?' $1)

if ([ -z $access_key ] || [ -z $list_id ]); then
  echo "Error parsing $1"
fi

if [ $(grep -c "${access_key}\|${list_id}" $DEFAULT_JSFILE) -gt 0 ]; then
  # Deactivate JFile
  echo "API keys detected, sanitizing: $DEFAULT_JSFILE"
  sed -ine "s:$access_key:$DEFAULT_SEARCH_KEY:g" $DEFAULT_JSFILE &&\
  sed -ine "s:$list_id:$DEFAULT_SEARCH_ID:g" $DEFAULT_JSFILE
else
  # Activate JFile
  echo "Activating API keys: $DEFAULT_JSFILE"
  sed -ine "s:$DEFAULT_SEARCH_KEY:$access_key:g" $DEFAULT_JSFILE &&\
  sed -ine "s:$DEFAULT_SEARCH_ID:$list_id:g" $DEFAULT_JSFILE
fi
