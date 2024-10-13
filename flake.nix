{
  description = "Development setup for waterwolfdev/opzones";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs { inherit system; };
      });
    in
    {
      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell {
          packages = with pkgs; [ python310 virtualenv ] ++
            (with pkgs.python310Packages; 
              let
                octodns = buildPythonPackage rec {
                    pname = "octodns";
                    version = "1.4.0";
                    src = fetchFromGitHub {
                      owner = "octodns";
                      repo = "octodns";
                      rev = "429a6be9ff8617bb284dbf69319f46982d88c469";
                      hash = "sha256-1s0mNIp7WctbrLf68aOp+nzVLcjc3E3IsMn+r+Z5fu8=";
                    };
                    doCheck = false;
                    propagatedBuildInputs = [
                      pkgs.python3Packages.pyyaml
                      pkgs.python3Packages.dnspython
                      pkgs.python3Packages.fqdn
                      pkgs.python3Packages.idna
                      pkgs.python3Packages.natsort
                      pkgs.python3Packages.python-dateutil
                      pkgs.python3Packages.six
                    ];
                  };
                  octodns-cloudflare = buildPythonPackage rec {
                    pname = "octodns-cloudflare";
                    version = "0.0.3";
                    src = fetchPypi {
                      inherit pname version;
                      sha256 = "13ee700fc416820d91d159c70de923f2c9d7a330b67600a5a8650b102cba5148";
                    };
                    doCheck = false;
                    propagatedBuildInputs = [
                      octodns
                      pkgs.python3Packages.pyyaml
                      pkgs.python3Packages.certifi
                      pkgs.python3Packages.charset-normalizer
                      pkgs.python3Packages.dnspython
                      pkgs.python3Packages.fqdn
                      pkgs.python3Packages.idna
                      pkgs.python3Packages.natsort
                      pkgs.python3Packages.python-dateutil
                      pkgs.python3Packages.requests
                      pkgs.python3Packages.six
                      pkgs.python3Packages.urllib3
                    ];
                  };
                in [ pip octodns octodns-cloudflare ]
            );
        };
      });
    };
}
