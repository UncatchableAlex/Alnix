{ ... }: {
  flake.nixosModules.pipewire = { pkgs, ... }: {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
      # If you want to use JACK applications, uncomment this
      # jack.enable = true;
    };

    # set the priority for playing audio. It's important that audio tries to play greedily through
    # HDMI, Bluetooth, then speakers in that order.
    services.pipewire.wireplumber.extraConfig = {
      "sink-priorities" = {
        "monitor.alsa.rules" = [
          {
            matches = [
              { "node.name" = "~alsa_output.*Speaker.*"; }
              { "node.name" = "~alsa_output.*analog.*"; }
            ];
            actions.update-props."priority.session" = 1000;
          }
          {
            matches = [
              { "node.name" = "~alsa_output.*HDMI.*"; }
              { "node.name" = "~alsa_output.*hdmi.*"; }
            ];
            actions.update-props."priority.session" = 3000;
          }
        ];
        "monitor.bluez.rules" = [
          {
            matches = [ { "node.name" = "~bluez_output.*"; } ];
            actions.update-props."priority.session" = 2000;
          }
        ];
      };

      "no-restore-default" = {
        "wireplumber.settings"."node.restore-default-targets" = false;
      };
    };

    # unconfirmed hack
    boot.extraModprobeConfig = ''
      options snd-hda-intel model=103c:888a,103c:888a
    '';
  };
}
