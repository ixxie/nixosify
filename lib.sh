#!/usr/bin/env bash

# ssh

run () {
  local id="$1"
  local target="$2"
  local cmd="$3"
  ssh -o IdentitiesOnly=yes \
      -o StrictHostKeyChecking=no \
      -o UserKnownHostsFile=/dev/null  \
      -o LogLevel=INFO \
      -i "${id}" root@"${target}" "${cmd}"

}

copy () {
  local id="$1"
  local from="$2"
  local to="$3"
  scp -o IdentitiesOnly=yes \
      -o StrictHostKeyChecking=no \
      -o UserKnownHostsFile=/dev/null  \
      -o LogLevel=INFO \
      -i "${id}" "${from}" "${to}"
}

# logging

phase () {
  local title="$1"

  # hardcoded style params
  local color='\e[208m'
  local default='\e[39m'
  local openTitle="<<${color}"
  local closeTitle="${default}>>"
  
  printf "\n${openTitle}${title}${closeTitle}\n\n"
}

# operating system

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

# status checks

isUp () {
  local target="$1"
  if timeout 1 nc -z "${target}" 22 &> /dev/null; then
    return 0
  else
    return 1
  fi
}

serverReady () {
  local id="$1"
  local target="$2"
  if isUp "${target}"; then
    return 0
  else
    return 1
  fi  
}

kexecReady () {
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

await () {
  local interval="$1"
  local command="$2"
  sleep "${interval}"
  printf "Awaiting ${command} "
  while ! $command;
  do
    printf '.'
    sleep "${interval}"
  done
  echo ' target back online!'
}
