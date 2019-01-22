#/bin/bash

DEFAULT_JSFILE='assets/js/main.js'

function usage() {
  echo "Usage: $0 credfile.json"
  exit 1
}  

function is_empty() {
  for string in $@; do
    if [ -z $string ]; then
      return true
    else
      false
    fi
  done
}

function is_file() {
  for file in $@; do
    echo $file
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

#if ([ -z $access_key ] || [ -z $list_id ]); then
#  echo "Error parsing $1"
#fi

if is_empty $access_key $list_id; then
  echo "Error parsing $1"
  exit 3
fi

d_access_keye=$(grep $access_key $DEFAULT_JFILE)
d_list_ide=$(grep $list_id $DEFAULT_JFILE)

if is_empty $d_access_key $d_list_id; then
  # Activate JFile
  sed -i -e "s:replace_access_key:$access_key:g" &&\
  sed -i -e "s:replace_access_token:$list_id:g"
else
  # Deactivate JFile
  sed -i -e "s:$access_key:replace_access_key:g" &&\
  sed -i -e "s:$list_id:replace_access_token:g"
fi
