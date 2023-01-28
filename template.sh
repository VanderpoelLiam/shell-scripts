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
  echo "USAGE: $program_name [-ab] [-c param_c -d param_d] e f"
  echo "  e            required argumment 1"
  echo "  f            required argumment 2"
  echo "  -a           optional flag 1"
  echo "  -b           optional flag 2"
  echo "  -c c_value   optional arg 1 with parameter param_c"
  echo "  -d d_value   optional arg 2 with parameter param_d"
  echo "  -v           enable verbosity"
  echo "  -h           display help"
  echo ""
  echo "DESCRIPTION: Describe the function here."
  echo ""
}

parse_args() {
  if [[ "${1-}" =~ ^-*h(elp)?$ ]]; then
    usage
    exit 1
  fi

  a='false'
  b='false'
  c='default_value'
  d='default_value'
  verbose='false'

  # INFO:
  # h - check for option -h without parameters
  # h: - check for option -h with parameter
  while getopts 'abvc:d:' flag; do
    case "${flag}" in
      a) a='true' ;;
      b) b='true' ;;
      c) c="${OPTARG}" ;;
      d) d="${OPTARG}" ;;
      v) verbose='true' ;;
      *) error "Unexpected option" ;;
    esac
  done

  shift "$((OPTIND - 1))"

  if [ $# -lt $num_required_args ]; then
    usage
    error "Please provide all required arguments"
  fi

  e=$1
  f=$2
}

parse_args "$@"
GLOBAL='global_variable'

cd "$(dirname "$0")"

log() {
    $verbose && echo "$*";
}

run_quietly() {
    if [ "$verbose" == "false" ]; then
        "$@" > /dev/null
    else
        "$@"
    fi
}

# ----------------------------
# ADDITIONAL FUNCTIONS GO HERE
# ----------------------------

main() {
    echo "a: $a"
    echo "b: $b"
    echo "c: $c"
    echo "d: $d"
    echo "e: $e"
    echo "f: $f"
    echo "verbose: $verbose"
    log "verbose is enabled"
    run_quietly echo "this runs quietly unless verbose enabled"
    echo "GLOBAL: $GLOBAL"
}

main
