{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  };
  outputs = { self, nixpkgs }:
    let pkgs = import nixpkgs { system = "x86_64-linux"; }; in {
      devShells.x86_64-linux.default = pkgs.mkShell {
        packages = with pkgs; [ cmake ninja gcc gdb clang-tools cppcheck python3 git ];
        shellHook = ''echo "BioSimX dev shell ready"'';
      };
    };
}
