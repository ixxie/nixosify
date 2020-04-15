#!/usr/bin/env bash
kit=$(dirname "$BASH_SOURCE")
source "${kit}"/ssh.sh

getOS () {
  local id="$1"
  local target="$2"
  OS=$(
    run "${id}" "${target}" '
      source /etc/os-release 
      echo ${NAME}
    ')
  echo "${OS}"
}

isNixOS () {
  local id="$1"
  local target="$2"
  OS=$(getOS "${id}" "${target}")
  if [[ "${OS}" = "NixOS" ]]; then
    return 0 
  else
    return 1
  fi
}

kexecNixOS () {
  local id="$1"
  local target="$2"
  run "${id}" "${target}" "
    apt-get update
    apt-get install -y screen
    cd /
    tar -xf /nixos-system-x86_64-linux.tar.xz
    screen -d -m ./kexec_nixos
    printf '\nExiting target\n\n'
    exit
  "
}
