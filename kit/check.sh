#!/usr/bin/env bash
kit=$(dirname "$BASH_SOURCE")
source "${kit}"/os.sh

isUp () {
  local target="$1"
  if timeout 1 nc -z "${target}" 22 &> /dev/null; then
    return 0
  else
    return 1
  fi
}

isReady () {
  local id="$1"
  local target="$2"
  if isUp "${target}"; then
    if isNixOS "${id}" "${target}"; then
      return 0
    else
      return 1
    fi
  else
    return 2
  fi  
}

awaitReboot () {
  local id="$1"
  local target="$2"
  local interval="$3"
  sleep "${interval}"
  while ! isReady "${id}" "${target}";
  do
    printf '//'
    sleep "${interval}"
  done
  sleep "${interval}"
  
  echo 'Target back online!'
}
