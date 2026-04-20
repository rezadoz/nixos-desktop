{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./host.nix
    ./packages.nix
  ];
}
