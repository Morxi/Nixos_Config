  {pkgs,config, ...}:
{  
    environment.systemPackages = with pkgs; [ yesplaymusic];
  nixpkgs.config.packageOverrides = pkgs: rec {
    yesplaymusic = pkgs.callPackage ./yesplaymusic.nix { };
  };

}