{ config, lib, pkgs, newScope, ... }:

with lib;
let

  pkg = pkgs.callPackage ./supergfxctl.nix { };
  cfg = config.services.supergfxd;
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

  config = mkIf cfg.enable {

    systemd.services."supergfxd" = {
      enable = true;
      restartIfChanged = true;
      wantedBy = [ "multi-user.target" ];
      description = "SuperGfxd";
      path = with pkgs; [ kmod ];
      before = [ "multi-user.target" ];
      environment =
        {
          IS_SUPERGFX_SERVICE = "1";
        };
      serviceConfig =
        {
          type = [ "Dbus" ];
          ExecStart = ''${pkg.supergfx}/bin/supergfxd'';
        };

    };

    services.dbus.packages = [ pkg.supergfx ];
    services.udev.packages = [ pkg.supergfx ];

    environment.etc."X11/xorg.conf.d/90-nvidia-screen-G05.conf".source =
      "${pkg.supergfx}/share/X11/xorg.conf.d/90-nvidia-screen-G05.conf";

    # environment.etc."udev/rules.d/90-supergfxd-nvidia-pm.rules".source =
    #   "${pkg.supergfx}/udev/rules.d/90-supergfxd-nvidia-pm.rules";

  };

}
