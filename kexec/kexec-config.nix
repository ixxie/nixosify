# new cmd: nix-build '<nixpkgs/nixos>' -A config.system.build.kexec_tarball -I nixos-config=./configuration.nix -Q -j 4

{ lib, pkgs, config, ... }:

with lib;

{
  imports = [ 
    <nixpkgs/nixos/modules/installer/netboot/netboot-minimal.nix> 
    ./autoreboot.nix 
    ./kexec.nix 
    ./justdoit.nix 
  ];

  networking.hostName = "kexec";

  boot.supportedFilesystems = [ "zfs" ];
  boot.loader.grub.enable = false;
  boot.kernelParams = [
    "console=ttyS0,115200"          # allows certain forms of remote access, if the hardware is setup right
    "panic=30" "boot.panic_on_fail" # reboot the machine upon fatal boot issues
  ];

  # ssh support
  systemd.services.sshd.wantedBy = mkForce [ "multi-user.target" ];
  users.users.root.openssh.authorizedKeys.keys = [ (builtins.getEnv "tempkey_pub") ];
}
