{
  flake.nixosModules.ledhack = { pkgs, ... }: {

    # Claude hack to use the sound module to mess with the keyboard leds somehow? wtf?
    boot.extraModprobeConfig = ''
      options snd-hda-intel model=103c:888a,103c:888a
    '';

    # give the normal user (me) write access to the brightness file for the mic mute button
    services.udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="leds", KERNEL=="hda::micmute", ATTR{trigger}="none", \
        RUN+="${pkgs.coreutils}/bin/chgrp users /sys/class/leds/%k/brightness", \
        RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/leds/%k/brightness"
    '';
  };
}
