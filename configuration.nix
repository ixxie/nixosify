{ config, pkgs, ... }: 

{

  imports =
  [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
  
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [ (builtins.getEnv "authkey_pub") ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
  };

}
