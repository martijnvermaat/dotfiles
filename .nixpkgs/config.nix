{
  packageOverrides = pkgs: rec {
    all = with pkgs; let

      # Backup script.
      backup = callPackage ./packages/backup {};

      # exa is broken in Nixpkgs 16.03.
      # Might be related to https://github.com/NixOS/nixpkgs/issues/14125
      exa = callPackage ./packages/exa {};

      # GNotifier add-on cannot find libnotify.
      # https://github.com/mkiol/GNotifier/issues/89
      firefox = pkgs.stdenv.lib.overrideDerivation pkgs.firefox (oldAttrs: {
        libs = oldAttrs.libs ++ [ (libnotify + "/lib") ];
      });

      # The gnome-open binary is provided by libgnome and not in my PATH
      # unless included top-level.
      gnome-open = gnome.libgnome;

      # texlive.combined.scheme-full is broken in Nixpkgs 16.03.
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

      # lesspipe is not in Nixpkgs 16.03.
      # https://github.com/NixOS/nixpkgs/pull/15338
      lesspipe = callPackage ./packages/lesspipe {};

      # Python with our beloved IPython and some libs we use in Emacs.
      # In NixOS 16.09, withPackages can be used instead of buildEnv.
      # https://github.com/NixOS/nixpkgs/pull/15804
      python = pkgs.python27.buildEnv.override {
        extraLibs = with pkgs.python27Packages; [
          epc
          flake8
          ipython
          jedi
        ];
      };

      # shellcheck is not a top-level package in 16.03.
      # https://github.com/NixOS/nixpkgs/pull/15972
      shellcheck = haskellPackages.ShellCheck;

      # tern is not in Nixpkgs 16.03.
      tern = callPackage ./packages/tern {};

    in buildEnv {
      name = "all";
      paths = [
        # Nix-related.
        nix-repl
        #nixops

        # General utilities.
        ag
        binutils
        colordiff
        dos2unix
        exa
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
        python27Packages.markdown2
        shellcheck
        tern
        # TODO: eslint, gocode, ...

        # Git.
        git
        gitAndTools.git-annex
        gitAndTools.git-crypt
        gitg

        # Secrets management.
        pass
        pwgen

        # Backup.
        backup
        borgbackup

        # Development tools.
        Fabric
        ansible2
        gnumake
        jq
        mysql55
        postgresql
        python27Packages.docker_compose
        sqlite-interactive
        vagrant

        # Python.
        python

        # LaTeX.
        ghostscript
        latex

        # Music.
        beets
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
        skype
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
