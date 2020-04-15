#!/usr/bin/env bash

run () {
  local id="$1"
  local target="$2"
  local cmd="$3"
  ssh \
    -i "${id}" \
    -o "StrictHostKeyChecking=no" \
    -o "UserKnownHostsFile=/dev/null"  \
    -o "LogLevel=INFO"  \
    root@"${target}" "${cmd}"
}

move () {
    local id="$1"
    local from="$2"
    local to="$3"
    scp \
      -i "${id}" \
      -o "StrictHostKeyChecking=no" \
      -o "UserKnownHostsFile=/dev/null"  \
      -o "LogLevel=INFO"  \
      "${from}" "${to}"
}
