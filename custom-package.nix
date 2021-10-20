  {pkgs,config, ...}:
{  
  nixpkgs.config.packageOverrides = pkgs: rec {
    yesplaymusic = pkgs.callPackage ./yesplaymusic.nix { };
  };

}