{
  packageOverrides = pkgs: rec {
    all = with pkgs; let
      # WTCC SSH script.
      wt = callPackage ./packages/wt {};

      # Patch nix-shell to not set PS1. We define our own indicator in .bashrc.
      nix = lib.overrideDerivation pkgs.nix (oldAttrs: {
        postPatch = "sed '/PS1=/d' -i scripts/nix-build.in";
      });

    in buildEnv {
      name = "all";
      paths = [
        # Nix-related.
        nix
        nix-repl

        # Emacs.
        emacs25-nox

        #
#        wt

        # Python.
#        python

        # Music.

        # Desktop.
        # chromium
        # devilspie2
        # dia
        # firefox
        # gimp
        # gnome3.cheese
        # gnome-open
        # libreoffice
        # shotwell
        # torbrowser
        # transmission_gtk
        # vlc
      ];
    };
  };

  allowUnfree = true;

  allowTexliveBuilds = true;

  firefox = {
    enableAdobeFlash = true;
    enableGoogleTalkPlugin = true;
    jre = false;
  };

  chromium = {
    enablePepperFlash = true;
    enablePepperPDF = true;
  };
}
