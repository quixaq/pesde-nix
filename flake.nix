{
  description = "pesde is a package manager for the Luau programming language, designed to prevent runtime lock-in.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    crane.url = "github:ipetkov/crane";
  };

  outputs =
    {
      self,
      nixpkgs,
      crane,
      ...
    }:
    let
      supportedSystems = nixpkgs.lib.systems.flakeExposed;
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      nixosModules.default =
        { pkgs, ... }:
        {
          environment.systemPackages = [
            self.packages.${pkgs.system}.default
          ];
        };

      packages = forAllSystems (
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
          default = craneLib.buildPackage {
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
      );
    };
}
