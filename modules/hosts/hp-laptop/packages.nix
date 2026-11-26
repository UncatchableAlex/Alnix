# List packages installed in system profile.
# You can use https://search.nixos.org/ to find more packages (and options).

{ self, ... }: {
  flake.nixosModules.packages = { pkgs, ... }: {

    environment.systemPackages = with pkgs; [

      # apps
      deluge
      sone
      haskellPackages.haskell-language-server
      dissent # bootleg discord
      imv # image viewer
      zathura # pdf viewer
      kdePackages.kservice
      self.packages.${pkgs.stdenv.hostPlatform.system}.alexNoctalia
      mpv # video player
      mpvScripts.uosc # mpv usability enancer
      (mpv.override {
        scripts = with pkgs.mpvScripts; [
          uosc
          thumbfast
        ]; # thumbfast = timeline thumbnails
      })

      # command-line tools:
      tree # gives a tree in the terminal for cli navigation
      yazi # file explorer for the terminal
      neovim
      ffmpeg
      p7zip
      wget
      htop
      pass
      entr

      # compilers and interpreters
      futhark
      ghc
      cabal-install
      python314 # python interpreter
      gcc # C compiler
      (haskellPackages.ghcWithPackages (
        ps: with ps; [
          megaparsec
          containers
          split
          array
          mtl
        ]
      ))
    ];
  };
}
