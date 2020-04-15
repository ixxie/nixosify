#!/usr/bin/env bash

phase () {
  local title="$1"

  # hardcoded style params
  local color='\e[208m'
  local default='\e[39m'
  local openTitle="<<${color}"
  local closeTitle="${default}>>"
  
  printf "\n${openTitle}${title}${closeTitle}\n\n"
}
