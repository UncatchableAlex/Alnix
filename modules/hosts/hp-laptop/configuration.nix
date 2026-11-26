{ self, ... }: {
  flake.nixosModules.hpLaptopConfiguration =
    {
      pkgs,
      lib,
      self',
      ...
    }:
    {
      imports = [
        self.nixosModules.hpLaptopHardware
        self.nixosModules.niri
        self.nixosModules.home
        self.nixosModules.packages
        self.nixosModules.greeter
        self.nixosModules.pipewire
        self.nixosModules.ledhack
      ];

      # Use the systemd-boot EFI boot loader.
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      boot.initrd.luks.devices."luks-8d2a8aa4-cf2f-49a3-9420-cc73d7a71baa".device =
        "/dev/disk/by-uuid/8d2a8aa4-cf2f-49a3-9420-cc73d7a71baa";
      networking.hostName = "nixos"; # Define your hostname.
      # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

      # Configure network proxy if necessary
      # networking.proxy.default = "http://user:password@proxy:port/";
      # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

      # Enable networking
      networking.networkmanager.enable = true;

      # Set your time zone.
      time.timeZone = "Europe/Copenhagen";

      # Select internationalisation properties.
      i18n.defaultLocale = "en_DK.UTF-8";

      i18n.extraLocaleSettings = {
        LC_ADDRESS = "da_DK.UTF-8";
        LC_IDENTIFICATION = "da_DK.UTF-8";
        LC_MEASUREMENT = "da_DK.UTF-8";
        LC_MONETARY = "da_DK.UTF-8";
        LC_NAME = "da_DK.UTF-8";
        LC_NUMERIC = "da_DK.UTF-8";
        LC_PAPER = "da_DK.UTF-8";
        LC_TELEPHONE = "da_DK.UTF-8";
        LC_TIME = "da_DK.UTF-8";
      };

      # Enable the X11 windowing system.
      # You can disable this if you're only using the Wayland session.
      services.xserver.enable = true;
      services.upower.enable = true;

      # Enable the KDE Plasma Desktop Environment.
      #services.displayManager.sddm.enable = true;

      # Configure keymap in X11
      services.xserver.xkb = {
        layout = "us";
        variant = "";
      };

      # Configure console keymap
      console.keyMap = "us";

      # Enable CUPS to print documents.
      services.printing.enable = true;

      # Enable sound with pipewire.
      services.pulseaudio.enable = false;
      security.rtkit.enable = true;
      hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
        settings.General.Enable = "Source,Sink,Media,Socket";
      };

      # Enable touchpad support (enabled default in most desktopManager).
      # services.libinput.enable = true;

      # Define a user account. Don't forget to set a password with ‘passwd’.
      users.users."alexm" = {
        isNormalUser = true;
        description = "Alex Meislich";
        extraGroups = [
          "networkmanager"
          "wheel"
        ];
        packages = [
          #  pkgs.kdePackages.kate
          #  thunderbird
        ];
      };

      # start the ssh agent automatically
      services.gnome.gcr-ssh-agent.enable = false;
      programs.ssh.startAgent = true;

      # Allow unfree packages
      nixpkgs.config.allowUnfree = true;

      # enable flakes
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      # Some programs need SUID wrappers, can be configured further or are
      # started in user sessions.
      # programs.mtr.enable = true;
      programs.gnupg.agent = {
        enable = true;
        enableSSHSupport = false;
      };

      nix.gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 10d";
      };

      # List services that you want to enable:

      # Enable the OpenSSH daemon.
      # services.openssh.enable = true;

      # Open ports in the firewall.
      # networking.firewall.allowedTCPPorts = [ ... ];
      # networking.firewall.allowedUDPPorts = [ ... ];
      # Or disable the firewall altogether.
      # networking.firewall.enable = false;

      # Copy the NixOS configuration file and link it from the resulting system
      # (/run/current-system/configuration.nix). This is useful in case you
      # accidentally delete configuration.nix.
      # system.copySystemConfiguration = true;

      # This option defines the first version of NixOS you have installed on this particular machine,
      # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
      #
      # Most users should NEVER change this value after the initial install, for any reason,
      # even if you've upgraded your system to a new NixOS release.
      #
      # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
      # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
      # to actually do that.
      #
      # This value being lower than the current NixOS release does NOT mean your system is
      # out of date, out of support, or vulnerable.
      #
      # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
      # and migrated your data accordingly.
      #
      # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
      system.stateVersion = "26.05"; # Did you read the comment?
    };
}
