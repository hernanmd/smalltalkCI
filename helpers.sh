#!/bin/bash

print_info() {
  printf "\e[0;34m%s\e[0m\n" "$1"
}

print_notice() {
  printf "\e[1;33m%s\e[0m\n" "$1"
}

print_success() {
  printf "\e[1;32m%s\e[0m\n" "$1"
}

print_error() {
  printf "\e[1;31m%s\e[0m\n" "$1" 1>&2
}

print_timed() {
  LAST_PRINT=$(date +%s)
  print_info "$1"
}

print_timed_result() {
  if [[ -n "${LAST_PRINT}" ]]; then
    diff=$(($(date +%s) - ${LAST_PRINT}))
    print_info "[$1: ${diff}s]"
  fi
}

print_help() {
  cat <<EOF
  USAGE: run.sh [options] /path/to/project

  This program prepares Smalltalk images/vms, loads projects and runs tests.

  OPTIONS:
    --baseline              Overwrite baseline.
    --baseline-group        Overwrite baseline group.
    --builder-ci            Use builderCI (default 'false').
    --directory             Overwrite directory.
    --excluded-categories   Overwrite categories to be excluded (Squeak only).
    --excluded-classes      Overwrite classes to be excluded (Squeak only).
    --force-update          Force an update in Squeak image (default 'false').
    -h | --help             Show this help text.
    -o | --keep-open        Keep image open and do not close on error.
    --script                Overwrite custom script to run (Squeak only).
    -s | --smalltalk        Overwrite Smalltalk image selection.

  EXAMPLE: run.sh -s "Squeak-trunk" --directory "subdir" /path/to/project

EOF
}

is_empty() {
  local var=$1

  [[ -z $var ]]
}

is_not_empty() {
  local var=$1

  [[ -n $var ]]
}

is_file() {
  local file=$1

  [[ -f $file ]]
}

is_dir() {
  local dir=$1

  [[ -d $dir ]]
}

program_exists() {
  local program=$1

  [[ $(which ${program} 2> /dev/null) ]]
}

is_travis_build() {
  [[ "${TRAVIS}" = "true" ]]
}

download_file() {
  local url=$1

  if is_empty "${url}"; then
    print_error "download_file() expects an URL."
    exit 1
  fi

  if program_exists "curl"; then
    curl -s "${url}"
  elif program_exists "wget"; then
    wget -q -O - "${url}"
  else
    print_error "Please install curl or wget."
    exit 1
  fi
}
