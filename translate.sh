#!/bin/bash

# exit when any command fails
set -e

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -s|--setup)
    INIT=YES
    shift # past argument
    ;;
    -p|--searchpath)
    SEARCHPATH="$2"
    shift # past argument
    shift # past value
    ;;
    -f|--file)
    FILE="$2"
    shift # past argument
    shift # past value
    ;;
    -b|--baselang)
    BASELANG="$2"
    shift # past argument
    shift # past value
    ;;
esac
done

echo -e "\n Command Opts:\n"

echo "INIT  = ${INIT}"
echo "SEARCH PATH     = ${SEARCHPATH}"
echo "TRANSLATE FILE    = ${FILE}"
echo "BASELANG         = ${BASELANG}"

if [[ $INIT == *"YES"* ]]; then
  # Based on https://github.com/soimort/translate-shell setup instructions
  echo -e "\nInstalling required dependencies\n"

  # Install fribidi
  brew install fribidi

  # Install curl
  brew install curl

  # Install gawk v4
  brew install gawk

  # translate-shell
  brew install translate-shell
fi

if [ -n "$SEARCHPATH" ]; then
  echo -e "\nChecking ${SEARCHPATH} for language directories\n"
  files=($(ls $SEARCHPATH))
  for item in ${files[*]}
    do
      size=${#item} 
      if [[ $item == *"-"* ]] && [[ $item != *".txt"* ]]; then
        LANGDIRS+=( $item )
	printf "   %s\n" $item
      elif [[ $size == 2 ]] && [[ $item != *".txt"* ]]; then
        LANGDIRS+=( $item )
        printf "   %s\n" $item
      fi
    done
  len=${#LANGDIRS[@]}
  if [[ $len == 0 ]]; then
    echo -e "\nERROR - Did not find any language directories in searchpath use metadata/ to your fastlane metadata path\n"
    exit 0
  fi
else
  echo -e "\nARGV ERROR - No search path set, exiting."
  exit 0
fi


if [ -n "$FILE" ] && [ -n "$BASELANG" ] && [ -n "$SEARCHPATH" ]; then
  BASEFILEPATH="${SEARCHPATH}${BASELANG}/$FILE"
  # Ex: en-US to en
  BASELANGONLY=${BASELANG:0:2}

  if [ ! -f "$BASEFILEPATH" ]; then
    echo -e "\nERROR - $FILE does not exist in $BASEFILEPATH, specify an existing filename and valid baselang\n"
    exit 0
  fi

  for langdir in ${LANGDIRS[*]}
    do
      if [ "$langdir" != "$BASELANG" ]; then
        echo "translating $langdir"
        DESTBASELANGONLY=${langdir:0:2}
        DESTFILEPATH="${SEARCHPATH}${langdir}/$FILE"
        rm $DESTFILEPATH > /dev/null 2>&1
        TRANSFILEPATH="file://${BASEFILEPATH}"
        echo "$BASELANGONLY:$DESTBASELANGONLY $TRANSFILEPATH > $DESTFILEPATH"
        trans $BASELANGONLY:$DESTBASELANGONLY $TRANSFILEPATH > $DESTFILEPATH
        echo -e "\nTranslated $FILE to $langdir"
      fi
    done

else
  echo -e "\nARGV ERROR - All of file, searchpath, and baselang args are required to start translation. Exiting."
  exit 0
fi
