# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, nixpkgs, ... }:

{
  imports =
    [
      <nixos-hardware/apple/macbook-pro/12-1>
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "l13"; # Define your hostname.
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/Istanbul";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.wlp3s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
    keyMap = "us";
  };

  # Desktop Configuration
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "intel" ];
  services.xserver.deviceSection = ''
    Option "DRI" "2"
    Option "TearFree" "true"
  '';
  services.xserver.dpi = 180;
  services.xserver.xkbOptions = "ctrl:nocaps";
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.displayManager.defaultSession = "none+xmonad";
  services.xserver.windowManager = {
    xmonad.enable = true;
    xmonad.enableContribAndExtras = true;
    xmonad.extraPackages = haskellPackages: [
      haskellPackages.xmonad
      haskellPackages.xmonad-contrib
      haskellPackages.xmonad-extras
      haskellPackages.xmobar
    ];
  };


  # Configure keymap in X11
  services.xserver.layout = "us";
  services.xserver.xkbVariant = "dvp";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.video.hidpi.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.furkhat = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  users.defaultUserShell = "/run/current-system/sw/bin/fish";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    variables = {
      GDK_SCALE = "2";
      GDK_DPI_SCALE = "0.5";
      _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
    };
    systemPackages = with pkgs; [
      # terminal 
      (
        import ./vim.nix
      )
      git
      st
      # GUI
      xbindkeys
      firefox
      dmenu
    ];
  };

  nixpkgs.config = {
    # st.conf = builtins.readFile ./st-config.h;
    st.patches = [./st-solarized-both-0.8.4.diff ./st-use-fish-and-bigger-font.diff];
  };

  programs.fish.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}

