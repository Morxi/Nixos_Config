{
  description = "NixOS configuration";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    nixos-hardware.url = github:NixOS/nixos-hardware/master;
  };
  # 引入 nixos-cn flake 作为 inputs
  inputs.nixos-cn = {
    url = "github:nixos-cn/flakes";
    # 强制 nixos-cn 和该 flake 使用相同版本的 nixpkgs
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { home-manager, nixpkgs, nixos-hardware, nixos-cn, ... }: {

    nixosConfigurations = {
      moxi-ga401 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          ./moxi-pkgs/custom-package.nix
          ./moxi-modules/mount-ga401-combine-disk.nix
          ./moxi-modules/supergfxd.nix

          nixos-hardware.nixosModules.asus-zephyrus-ga401
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.moxi = ./moxi-home.nix;
          }
          ({ ... }: {
            # 使用 nixos-cn flake 提供的包
            environment.systemPackages =
              [ nixos-cn.legacyPackages.x86_64-linux.netease-cloud-music ];
            # 使用 nixos-cn 的 binary cache
            nix.binaryCaches = [
              "https://nixos-cn.cachix.org"
            ];
            nix.binaryCachePublicKeys = [ "nixos-cn.cachix.org-1:L0jEaL6w7kwQOPlLoCR3ADx+E3Q8SEFEcB9Jaibl0Xg=" ];

            imports = [
              # 将nixos-cn flake提供的registry添加到全局registry列表中
              # 可在`nixos-rebuild switch`之后通过`nix registry list`查看
              nixos-cn.nixosModules.nixos-cn-registries

              # 引入nixos-cn flake提供的NixOS模块
              nixos-cn.nixosModules.nixos-cn
            ];
          })
        ];
      };
    };
  };
}
