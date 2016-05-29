{
  packageOverrides = pkgs: rec {
    all = with pkgs; buildEnv {
      name = "all";
      paths = [
        # Nix-related.
        nix-repl

        # General utilities.
        ag
        dos2unix
        file
        htop
        psmisc
        tree
        usbutils
        wget
        which

        # Archives.
        unrar

        # Emacs.
        editorconfig-core-c
        emacs24-nox
        python27Packages.markdown2
        # todo: jedi, eslint, gocode, ...

        # Git.
        git
        gitAndTools.git-annex
        gitAndTools.git-crypt
        gitg

        # Secrets management.
        pass
        pwgen

        # Development tools.
        jq
        sqlite-interactive

        # Music.
        # TODO: wrap beets with pillow dep
        beets
        imagemagick # or pillow
        vorbis-tools

        # Desktop.
        chromium
        devilspie2
        firefox
        transmission_gtk

        #lesspipe
      ];
    };
  };

  allowUnfree = true;

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
