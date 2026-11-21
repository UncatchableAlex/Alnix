# modules/features/firefox.nix
{
  flake.nixosModules.home = {
    home-manager.users.alexm.programs.firefox = {
      enable = true;
      policies.ExtensionSettings = {
        # AdGuard AdBlocker
        "adguardadblocker@adguard.com" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/adguard-adblocker/latest.xpi";
          private_browsing = true;
        };

        # I still don't care about cookies
        "idcac-pub@guus.ninja" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/istilldontcareaboutcookies/latest.xpi";
          private_browsing = true;
        };

        # Netflix 1080p UA
        "{221ca73e-12bd-11f1-b1cd-2cf05d5d458e}" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/netflix-1080p-ua/latest.xpi";
        };
        "pywalfox@frewacom.org" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/pywalfox/latest.xpi";
          private_browsing = true;
        };
      };
    };
  };
}
