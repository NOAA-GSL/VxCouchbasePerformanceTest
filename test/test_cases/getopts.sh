#!/usr/bin/env bash
Usage="usage: $0 -s server -S subset(or database) [-p(prints prologue)]"
server=""
while getopts 'hps:S:' OPTION; do
  case "$OPTION" in
    h)
      echo "$Usage"
      ;;
    p)
      echo $prologue
      exit 1
      ;;
    S)
      subset="$OPTARG"
      ;;
    s)
      server="$OPTARG"
      ;;
    *?)
      echo "$Usage" >&2
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"
if [ "X${subset}" = "X" ]; then
        echo "No subset specified: $Usage"
        exit 1
else
        echo "Using subset $subset"
fi
if [ "X${server}" = "X" ]; then
        echo "No server specified: $Usage"
        exit 1
else
        echo "Using server $server"
fi

