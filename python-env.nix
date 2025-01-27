{ pkgs ? import <nixpkgs> { } }:
{
  python-chip = pkgs.mkShell {
    buildInputs = with pkgs; [
      python312
      python312Packages.pip
      python312Packages.venv
    ];
    
    shellHook = ''
      if [ ! -d "venv" ]; then
        python -m venv venv
      fi
      source venv/bin/activate
      pip list | grep -F volare || pip install volare
    '';
  };
}
