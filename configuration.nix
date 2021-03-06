# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, ... }:

{


  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };


  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./moxi-modules/asus-charging-limit.nix
    ];


  services.charge-limit.enable = true;
  services.charge-limit.limits = 80;
  
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.useOSProber = true;


  programs.dconf.enable = true;
  boot.supportedFilesystems = [ "ntfs" ];
  # virtualisation.oci-containers.backend = "docker";
  #  virtualisation.oci-containers.containers = {
  #    shellclash = {

  #       autoStart = true;
  #    };
  # };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  networking.hostName = "moxi-ga401"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # Provide networkmanager for easy wireless configuration.
  networking.networkmanager.enable = true;
  networking.wireless.enable = false;

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.wlp2s0.useDHCP = true;

  # Configure network proxy if necessary
  networking.proxy.default = "http://192.168.122.246:7890/";
  networking.proxy.noProxy = "172.16.0.0/16,192.168.0.0/16,127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Enable the X11 windowing system.
  boot.kernelParams = [ "nvidia-drm.modeset=0" "amd_iommu=on" "pcie_aspm=off" ];
  # services.xserver.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_5_14;
  boot.kernelModules = [ "vfio" "vfio_iommu_type1" "vfio_pci" "vfio_virqfd" ];
  boot.initrd.kernelModules = [ "amdgpu" "kvm-amd" "vfio-pci" ];
  boot.extraModprobeConfig = "options vfio-pci ids=10de:2520,10de:228e";

  #services.supergfxd.enable = true;
  nixpkgs.config.allowUnfree = true;
  # Enable the Plasma 5 Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  #services.xserver.desktopManager.plasma5.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;

  #  enable XFCE
  # services.xserver = {
  #   enable = true;
  #   desktopManager = {
  #     xterm.enable = false;
  #     xfce.enable = true;
  #   };
  #   displayManager.defaultSession = "xfce";
  # };
  services.xserver =
    {
      enable = true;
      displayManager =
        {
          gdm.enable = true;
        };
      desktopManager =
        {
          gnome.enable = true;
        };
          displayManager.defaultSession = "gnome";

    };

  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.nvidia.modesetting.enable = false;
  hardware.nvidia.prime.offload.enable = false;
  # Configure keymap in X11
  services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  time.hardwareClockInLocalTime = true;
  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  i18n.inputMethod = {
    enabled = "ibus";
    ibus.engines = with pkgs.ibus-engines; [ rime ];
  };
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.moxi = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "libvirtd" ]; # Enable ‘sudo’ for the user.
  };

  nix.binaryCaches = [ "https://mirrors.bfsu.edu.cn/nix-channels/store" "https://cache.nixos.org/" ];
  # List packages installed in system profile. To search, run:
  # $ nix search wget


  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    firefox
    wineWowPackages.stable
    virt-manager
    scream
  ];


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.supergfxd.enable = true;
  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 80 443 8080 ];
  networking.firewall.allowedUDPPorts = [ 53 ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  # i18n.inputMethod.enabled = "fcitx5";
  # i18n.inputMethod.fcitx.engines = with pkgs.fcitx-engines; [ rime ];
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "unstable"; # Did you read the comment?

}


