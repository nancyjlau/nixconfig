{ pkgs }:

{
  python-chip = pkgs.mkShell {
    buildInputs = with pkgs; [
      python312
      python312Packages.pip
      python312Packages.venv
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
}
