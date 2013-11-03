#!/bin/bash

command=$1

help () {
  title "Usage:"
  row "    mao [module] [command]"
  title "Commands:"
  row  "    help         Show this help and exit."
  echo ""
}

run () {
  local modulePath=$(echo "$1" | sed 's/\([^\/]*\)\.go$/mao_\1.go/')
  local errorOutputPath="/tmp/mao-errors-"$[ ( $RANDOM % 99999 )  + 1 ]
  rm -f "$modulePath"
  local source=$(cat $1)
  local module="package main
import . \"github.com/azer/mao\"
$source"

  local bddStartsAt=$(echo "$module" | grep -n "Desc(" -m 1 |cut -f1 -d:)
  module=$(echo "$module" | sed "${bddStartsAt}i func main() {
  ")
  module="$module
  PrintTestSummary()
  }"

  echo "$module" >> "$modulePath"

  result=$(MAO_LINENO_START=3 go run "$modulePath" 2>&1)
  rm -f "$modulePath"

  isSuccessful=$(echo "$result" | grep success)
  areTestsFailed=$(echo "$result" | grep "assertions failed.")
  lineCount=$(echo "$result" | wc -l)

  if [[ $lineCount -eq 2 ]] && [ -n "$isSuccessful" ]; then
      echo "$result
      "
  elif [ -n "$areTestsFailed" ]; then
      printError "$result
      "
      exit 1
  else
      while read -r line; do
          local ln=$(echo "$line" | grep -oh ".go:[0-9]*" | sed 's/.go://')

          if [ -z "$ln" ]; then
            echo "$line"
          else
            oln=$(expr "$ln" - 3)
            echo "$line" | sed "s/.go:$ln/.go:$oln/"
          fi

      done <<< "$result"
      exit 1
  fi

}

row () {
  echo -e "    $1"
}

colored () {
  local color="\033[$2m"
  local nc='\033[0m'
  row "${color}$1${nc}"
}

info () {
  colored "$1" "90"
}

title () {
  echo ""
  row "\033[1m$1\033[0m"
  echo ""
}

printError () {
  echo "$@" 1>&2;
}

if [ "$command" = "register" ]; then
  register $@
elif [ -n "$command" ]; then
    run "$command"
elif [ "$command" = "help" ]; then
  help $@
else
  help $@
fi
