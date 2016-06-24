{
  packageOverrides = pkgs: rec {
    all = with pkgs; let

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
          fp;
      };

      # lesspipe is not in Nixpkgs 16.03.
      # https://github.com/NixOS/nixpkgs/pull/15338
      lesspipe = callPackage ./packages/lesspipe.nix {};

      # Python with our beloved IPython and some libs we use in Emacs.
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
        file
        htop
        lesspipe
        pciutils
        psmisc
        tree
        usbutils
        wget
        which

        # Archives.
        unrar
        unzip

        # Emacs.
        editorconfig-core-c
        emacs24-nox
        python27Packages.markdown2
        shellcheck
        # TODO: jedi, eslint, gocode, ...

        # Git.
        git
        gitAndTools.git-annex
        gitAndTools.git-crypt
        gitg

        # Secrets management.
        pass
        pwgen

        # Development tools.
        gnumake
        jq
        sqlite-interactive

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
        firefox
        gimp
        libreoffice
        transmission_gtk
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
