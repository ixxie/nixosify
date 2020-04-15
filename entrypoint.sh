#!/usr/bin/env bash
kit="$(dirname "$BASH_SOURCE")/kit"
source "${kit}"/logging.sh
source "${kit}"/os.sh
source "${kit}"/check.sh

# Script to use Clever's kexec method 
# to install NixOS on a temporary host
# and save the resulting image

target="$1"
tempkey="$2"
export tempkey_pub="$3"
authkey_pub="$4"

root_dir="$(dirname "$BASH_SOURCE")"

phase 'Pass keys'

echo "${tempkey}" > "${root_dir}/tempkey"
chmod 600 "${root_dir}/tempkey"
echo "${tempkey_pub}" > "${root_dir}/tempkey.pub"
chmod 644 "${root_dir}/tempkey.pub"

phase 'Move key to target'

move "${root_dir}/tempkey" \
  "${root_dir}/tempkey.pub" \
  "root@${target}:/ssh_pubkey"

phase 'Copy nixos kexec tarball'

move "${root_dir}/tempkey" \
  /nixos-system-x86_64-linux.tar.xz \
  "root@${target}:/"

phase 'Booting into NixOS with kexec'

kexecNixOS "${root_dir}/tempkey" "${target}"
 
phase 'Waiting for kexec to boot up NixOS'

awaitReboot "${root_dir}/tempkey" "${target}" 10

phase 'Formatting disk & generating configuration'

run "${root_dir}/tempkey" "${target}" '
  mkfs.ext4 -F /dev/sda1;
  mount /dev/sda1 /mnt;
  nixos-generate-config --root /mnt;
'

phase 'Copying temporary configuration to target'

move "${root_dir}/tempkey" \
  "${root_dir}/configuration.nix" \
  "root@${target}:/mnt/etc/nixos/configuration.nix"

phase 'Installing NixOS'

run "${root_dir}/tempkey" "${target}" "
  export authkey_pub='${authkey_pub}';
  nixos-install;
  reboot;
"
 
echo "Target ${target} succesfully converted to NixOS!"
