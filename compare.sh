#!/bin/sh

COLUMNS='1,1'

Usage() {
  echo 'Usage: compare.sh [-h] [-i column number,column number] file1.csv file2.csv'
  echo ''
  echo '    -h                   : Prints this usage message'
  echo '    -i col num1,col num2 : Column numbers to compare, default is 1,1'
  echo '    file1.csv            : First comparison file in CSV format'
  echo '    file2.csv            : Second comparison file in CSV format'
  echo '    Example: ./compare.sh -i 3,2 partial_list.csv complete_list.csv'
}

# Process the command line
OPTIND=1         #Reset in case getopts has been used previously in the shell.

while getopts ":hi:" opt
do
  case "$opt" in
    h)  Usage      # the help switch
        exit 0
        ;;
    i)  if [[ "$OPTARG" =~ ^[[:digit:]].*,[[:digit:]].* ]]; then
          COLUMNS=$OPTARG
        else
          echo "Invalid switch argument: $OPTARG. The -i switch requires integer,integer e.g. -i 3,9" 1>&2
          exit 0
        fi
        ;;
    \?) echo "Invalid option: $OPTARG" 1>&2
        exit 0
        ;;
    :)  echo "Invalid option: $OPTARG requires an argument" 1>&2
        exit 0
        ;;
    *)  Usage
        exit 0
        ;;
  esac
done

shift $((OPTIND -1))

if [[ $# -ne 2 ]]; then
  echo "Two CSV file names are required as command arguments."
  Usage
  exit 0
elif [[ ! -e "$1" ]]; then
  echo "$1 does not exist."
  exit 1
elif [[ ! -f "$1" ]]; then
  echo "$1 is not a regular file."
  exit 1
elif [[ ! -r "$1" ]]; then
  echo "$1 is not readable."
  exit 1
elif [[ ! -e "$2" ]]; then
  echo "$2 does not exist."
  exit 1
elif [[ ! -f "$2" ]]; then
  echo "$2 is not a regular file."
  exit 1
elif [[ ! -r "$2" ]]; then
  echo "$2 is not readable."
  exit 1
fi

FILE1="$1"
FILE2="$2"
COL1=$(echo $COLUMNS | cut -d, -f1)
COL2=$(echo $COLUMNS | cut -d, -f2)

IFS=$'\n'
for LINE in $(cat "$FILE2")
do
  FIELD=$(echo $LINE | awk -vFPAT='([^,]*)|("[^"]+")' '{print $b}' b="$COL2")

  awk -vFPAT='([^,]*)|("[^"]+")' '{IGNORECASE = 1} ($a == c) {print $0}' \
                          a="$COL1" c="$FIELD" $FILE1 | grep -q '[^.]'
  RC="$?"
  
  if [[ "$RC" -eq 1 ]]; then
    echo "$LINE"
  fi
done
