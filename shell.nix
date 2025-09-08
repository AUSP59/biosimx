{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  packages = with pkgs; [ cmake ninja gcc gdb clang-tools cppcheck python3 git ];
}
