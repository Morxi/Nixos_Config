{ config, lib, pkgs, newScope, ... }:

with lib;
let
callPackage = path: overrides:
    let f = import path;
    in f ((builtins.intersectAttrs (builtins.functionArgs f) allPkgs) // overrides);
  pkg = callPackage ./supergfxctl.nix { };
in

{


  options = {
    services.supergfxd = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = "Enable supergfxd  Service.";
      };

    };

  };

  config = mkIf config.services.supergfxd.enable {

    systemd.services."supergfxd" = {
      enable = true;
      restartIfChanged = true;
      wantedBy = [ "multi-user.target" ];
      description = "SuperGfxd";
      before = [ "multi-user.target" ];
      environment =
        {
          IS_SUPERGFX_SERVICE = 1;
        };
      type = [ "Dbus" ];
      ExecStart = ''${pkg}/bin/supergfxd'';

    };

    services.dbus.packages = [ pkg.supergfxctl ];


    environment.etc."X11/xorg.conf.d/90-nvidia-screen-G05.conf".source =
      "${pkg}/share/X11/xorg.conf.d/90-nvidia-screen-G05.conf";

    environment.etc."udev/rules.d/90-supergfxd-nvidia-pm.rules".source =
      "${pkg}/udev/rules.d/90-supergfxd-nvidia-pm.rules";

  };

}
