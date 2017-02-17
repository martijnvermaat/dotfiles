{
  packageOverrides = pkgs: rec {
    all = with pkgs; let
      # The gnome-open binary is provided by libgnome and not in my PATH
      # unless included top-level.
      gnome-open = gnome.libgnome;

      # mycli version in Nixpkgs 16.09 is old, we packaged 1.8.0.
      mycli = callPackage ./packages/mycli {};

      # Python with our beloved IPython and some libs we use in Emacs.
      python = pkgs.python35.withPackages (ps: with ps; [
        epc
        ipython
        jedi
        flake8
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
        bind
        binutils
        colordiff
        coreutils
        direnv
        dos2unix
        file
        gnugrep
        htop
        lesspipe
        moreutils
        mtr
        tree
        wget
        which

        # Archives.
        unrar
        unzip
        zip

        # Emacs.
        editorconfig-core-c
        emacs25-nox
        shellcheck
        tern
        # TODO: eslint, gocode, ...

        # Git.
        git
        gitAndTools.git-crypt

        # Secrets management.
        gnupg
        pass
        pwgen

        # Development tools.
        Fabric
        ansible2
        awscli
        consul
        gnumake
        jq
        mycli
        sqlite-interactive
        vagrant
        wt

        # Python.
        python

        # Music.
        faad2
        imagemagick # or pillow (TODO: wrap beets with this dep)
        vorbis-tools
        youtube-dl

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
