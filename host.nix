{ config, pkgs, ... }:

{
  networking.hostName = "enterprise";
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  swapDevices = [
    {
      device = "/swapfile";
      size = 8192; # MBs
            }
          ];

  # Boot
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/nvme0n1";
  boot.loader.grub.useOSProber = true;
  #boot.loader.systemd-boot.enable = true;
  #boot.loader.efi.canTouchEfiVariables = true;

  # Desktop — KDE Plasma
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Audio
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  fonts = {
    enableDefaultPackages = false;
    packages = with pkgs; [
      corefonts dejavu_fonts gyre-fonts liberation_ttf unifont
      cozette dina-font
      nerd-fonts.iosevka-term nerd-fonts.zed-mono nerd-fonts.meslo-lg
      noto-fonts
      noto-fonts-color-emoji
    ];
    fontconfig = {
    enable = true;
    useEmbeddedBitmaps = true;   # for Firefox emoji rendering
    };
  };

  # fstab
    fileSystems."/run/media/bread/cabin" = {
      device = "/dev/disk/by-uuid/3eb94e48-ca1e-446b-ab5e-a68def1a6c99";
      fsType = "ext4";

      options = [
        "nofail"
        "x-systemd.automount"
        "x-systemd.device-timeout=5"
        "x-gvfs-show"   # makes it appear nicely in GNOME/KDE file managers
  ];
};

  # Networking
  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 8000 53 5300 ];
    allowedUDPPorts = [ 53 5300 ];
  };
  boot.kernel.sysctl = {
    "net.ipv4.conf.eth0.forwarding" = 1;    # port forwarding
  };
  networking = {
    firewall.extraCommands = ''
      iptables -A PREROUTING -t nat -i eth0 -p TCP --dport 80 -j REDIRECT --to-port 8000
      iptables -A PREROUTING -t nat -i eth0 -p TCP --dport 53 -j REDIRECT --to-port 5300
      iptables -A PREROUTING -t nat -i eth0 -p UDP --dport 53 -j REDIRECT --to-port 5300
    '';
  };
  # Services
  services.nginx = {
    enable = true;
    virtualHosts."localhost" = {
    root = "/var/www";
    locations."/" = {
    tryFiles = "$uri $uri/ /index.html";
      };
     };
    };
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user="bread";
  };

  # Printing
  services.printing.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;

  #--- NVIDIA ---#
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
  };
  hardware.graphics.enable = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.production;

  # Nix settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # System-wide shell
  programs.zsh.enable = true;
  programs.steam = {
  enable = true;
  remotePlay.openFirewall = true;
  dedicatedServer.openFirewall = true;
  localNetworkGameTransfers.openFirewall = true;
  };

  # User account
  users.users.bread = {
    isNormalUser = true;
    description = "bread";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" ];
    shell = pkgs.zsh;
  };

  system.stateVersion = "24.11";
}
