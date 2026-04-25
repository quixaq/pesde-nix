/*
  pesde-nix v0.1.3
  Copyright (C) 2026  Quixaq

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

{
  description = "A package manager for the Luau programming language, supporting multiple runtimes including Roblox and Lune";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    crane.url = "github:ipetkov/crane";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      crane,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        craneLib = crane.mkLib pkgs;

        src = pkgs.fetchFromGitHub {
          owner = "pesde-pkg";
          repo = "pesde";
          rev = "e57b4c2db9eaf295c8af998212f427ea039ed46e";
          hash = "sha256-+8SneWw3UQwXg1IV1zn0OM1ySAJpcvMqyoQd7eYAarE=";
        };
      in
      {
        packages.default = craneLib.buildPackage {
          inherit src;

          cargoExtraArgs = "--features bin";

          nativeBuildInputs = [
            pkgs.pkg-config
          ];

          buildInputs = [
            pkgs.openssl
            pkgs.dbus
          ]
          ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
            pkgs.libiconv
            pkgs.darwin.apple_sdk.frameworks.Security
            pkgs.darwin.apple_sdk.frameworks.SystemConfiguration
          ];
        };
      }
    )
    // {
      nixosModules.default =
        { pkgs, ... }:
        {
          environment.systemPackages = [
            self.packages.${pkgs.system}.default
          ];
        };
    };
}
