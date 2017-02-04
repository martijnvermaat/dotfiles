{
  packageOverrides = pkgs: rec {
    all = with pkgs; let

      # Some packages we need from the unstable channel.
      pkgsUnstable = import (fetchTarball "https://github.com/NixOS/nixpkgs-channels/archive/f673243aff0bc9ae4d2e96ccd60124ff9fe5b103.tar.gz") {};

      awscli = pkgsUnstable.awscli;

      # Backup script.
      backup = callPackage ./packages/backup {};

      # The gnome-open binary is provided by libgnome and not in my PATH
      # unless included top-level.
      gnome-open = gnome.libgnome;

      # texlive.combined.scheme-full is broken in Nixpkgs 16.09.
      # https://github.com/NixOS/nixpkgs/issues/10026
      latex = texlive.combine {
        inherit (texlive)
          scheme-basic
          beamer
          extsizes
          ms
          metafont
          ec
          tex-gyre
          qpxqtx
          cm-super
          txfonts
          preprint
          multirow
          ntgclass
          placeins
          pxfonts
          gastex
          listings
          cleveref
          hyphenat
          type1cm
          fp
          caption
          eurosym;
      };

      # mycli version in Nixpkgs 16.09 is old, we packaged 1.8.0.
      mycli = callPackage ./packages/mycli {};

      # Python with our beloved IPython and some libs we use in Emacs.
      python = pkgs.python27.withPackages (ps: with ps; [
        epc
        ipython
        jedi
        pylint
      ]);

      # tern is not in Nixpkgs 16.09.
      tern = callPackage ./packages/tern {};

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
        #nixops

        # General utilities.
        ag
        bc
        binutils
        colordiff
        dos2unix
        file
        htop
        lesspipe
        moreutils
        mtr
        pciutils
        powertop
        psmisc
        tree
        usbutils
        wget
        which

        # Archives.
        unrar
        unzip
        zip

        # Emacs.
        editorconfig-core-c
        emacs24-nox
        shellcheck
        tern
        # TODO: eslint, gocode, ...

        # Git.
        git
        gitAndTools.git-annex
        gitAndTools.git-crypt
        gitg

        # Secrets management.
        gnupg
        keybase
        pass
        pwgen

        # Backup.
        backup
        borgbackup

        # Development tools.
        Fabric
        ansible2
        awscli
        consul
        gnumake
        jq
        mycli
        mysql55
        postgresql
        python27Packages.docker_compose
        sqlite-interactive
        vagrant
        wt

        # Python.
        python

        # LaTeX.
        ghostscript
        latex

        # Music.
        beets
        faad2
        imagemagick # or pillow (TODO: wrap beets with this dep)
        vorbis-tools
        youtube-dl

        # Desktop.
        chromium
        devilspie2
        dia
        firefox
        gimp
        gnome3.cheese
        gnome-open
        libreoffice
        shotwell
        transmission_gtk
        vlc
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
