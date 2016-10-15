{ stdenv, fetchurl, fetchFromGitHub, pythonPackages }:

let
  sqlparse = pythonPackages.buildPythonPackage rec {
    name = "sqlparse-${version}";
    version = "0.1.19";

    src = fetchurl {
      url = "mirror://pypi/s/sqlparse/${name}.tar.gz";
      sha256 = "1s2fvaxgh9kqzrd6iwy5h7i61ckn05plx9np13zby93z3hdbx5nq";
    };

    buildInputs = with pythonPackages; [ pytest ];
    checkPhase = ''
      py.test
    '';

    # Package supports 3.x, but tests are clearly 2.x only.
    doCheck = false;

    meta = with stdenv.lib; {
      description = "Non-validating SQL parser for Python";
      longDescription = ''
        Provides support for parsing, splitting and formatting SQL statements.
      '';
      homepage = https://github.com/andialbrecht/sqlparse;
      license = licenses.bsd3;
      maintainers = with maintainers; [ nckx ];
    };
  };
  prompt_toolkit = pythonPackages.prompt_toolkit.override(self: rec {
    name = "prompt_toolkit-${version}";
    version = "1.0.7";
    src = fetchurl {
      sha256 = "1vyjd0b7wciv55i19l44zy0adx8q7ss79lhy2r9d1rwz2y4822zg";
      url = "https://pypi.python.org/packages/dd/55/2fb4883d2b21d072204fd21ca5e6040faa253135554590d0b67380669176/${name}.tar.gz";
    };
  });
in

pythonPackages.buildPythonPackage rec {
  name = "mycli-${version}";
  version = "1.8.0";

  src = fetchFromGitHub {
    sha256 = "1dcxxzxisgb36z8yr3n78mb2mi1xp51qq986nbhb300hi0zg01v7";
    rev = "v${version}";
    repo = "mycli";
    owner = "dbcli";
  };

  propagatedBuildInputs = with pythonPackages; [
    pymysql configobj sqlparse prompt_toolkit pygments click pycrypto
  ];

  postPatch = ''
    substituteInPlace setup.py --replace "==" ">="
  '';

  meta = with stdenv.lib; {
    inherit version;
    description = "Command-line interface for MySQL";
    longDescription = ''
      Rich command-line interface for MySQL with auto-completion and
      syntax highlighting.
    '';
    homepage = http://mycli.net;
    license = licenses.bsd3;
  };
}
