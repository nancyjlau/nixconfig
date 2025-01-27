{
  description = "Development environments";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells = {
          python-chip = pkgs.mkShell {
            buildInputs = with pkgs; [
              python312
              python312Packages.pip
              virtualenv  # changed from venv
              python312Packages.matplotlib
              python312Packages.ipykernel
              python312Packages.cmake
            ];
            
            shellHook = ''
              if [ ! -d "venv" ]; then
                python -m venv venv
              fi
              source venv/bin/activate
              pip list | grep -F volare || pip install volare
            '';
          };
        };
      }
    );
}
