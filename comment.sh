#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
if [[ "${TRACE-0}" == "1" ]]; then
  set -o xtrace
fi

program_name=$0

# Declare the number of required args
num_required_args=2

error() {
  echo "[ERROR]: $*" >&2
  exit 1
}

usage() {
  echo ""
  echo "USAGE: $program_name [-u] filename pattern"
  echo "  filename   specify input file"
  echo "  pattern    specify regex pattern to match"
  echo "  -u         uncomment matched line"
  echo "  -h         display help"
  echo ""
  echo "DESCRIPTION: Comment and uncomment the line matched by the pattern."
  echo "Default behaviour is to comment out the line."
  echo ""
}

parse_args() {
  if [[ "${1-}" =~ ^-*h(elp)?$ ]]; then
    usage
    exit 1
  fi

  uncomment='false'

  while getopts 'u' flag; do
    case "${flag}" in
      u) uncomment='true' ;;
      *) error "Unexpected option" ;;
    esac
  done

  shift "$((OPTIND - 1))"

  if [ $# -lt $num_required_args ]; then
    usage
    error "Please provide all required arguments"
  fi

  filename=$1
  pattern=$2
}

parse_args "$@"

cd "$(dirname "$0")"

main() {
  if [[ "$uncomment" = 'true' ]]; then
    sed -i "s/^\# \(.*$pattern.*$\)/\1/" "$filename"
  else
    sed -i "s/\(^.*$pattern.*$\)/# \1/" "$filename"
  fi
}

main "$@"
