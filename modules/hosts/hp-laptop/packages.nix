# List packages installed in system profile.
# You can use https://search.nixos.org/ to find more packages (and options).

{ self, ... }: {
  flake.nixosModules.packages = { pkgs, ... }: {

    environment.systemPackages = with pkgs; [
      wget
      htop
      deluge
      p7zip
      pass
      sone
      ghc
      cabal-install
      haskellPackages.haskell-language-server
      python314 # python interpreter
      gcc # C compiler
      dissent # bootleg discord
      imv # image viewer
      mpv # video player
      mpvScripts.uosc # mpv usability enancer
      zathura # pdf viewer
      ffmpeg
      kdePackages.kservice
      tree # gives a tree in the terminal for cli navigation
      yazi # file explorer for the terminal
      neovim
      self.packages.${pkgs.stdenv.hostPlatform.system}.alexNoctalia
      (haskellPackages.ghcWithPackages (
        ps: with ps; [
          megaparsec
          containers
          split
          array
          mtl
        ]
      ))
      (mpv.override {
        scripts = with pkgs.mpvScripts; [
          uosc
          thumbfast
        ]; # thumbfast = timeline thumbnails
      })
    ];
  };
}
