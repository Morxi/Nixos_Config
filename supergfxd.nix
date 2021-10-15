{ config, lib, pkgs, ... }:

with lib;

let

  pkg = pkgs.supergfxctl;

in

{

  options = {

    services.supergfx = {

      enable = mkEnableOption "the digimend drivers for Huion/XP-Pen/etc. tablets";

    };

  };


  config = mkIf cfg.enable {

    systemd.services."supergfxd" = {
      enable = true;
      restartIfChanged = true;
      wantedBy =[''multi-user.target''];
      unitConfig = {
        Description = "SuperGfxd";
        ConditionPathExists = "%I";
        Before=[''multi-user.target''];
      };
      environment =
        {
          IS_SUPERGFX_SERVICE = 1;
        };
      serviceConfig = {
        Type = "Dbus";
        ExecStart = "${pkgs}/bin/supergfxd";
        
      };

    services.dbus.packages = [ pkgs.supergfxctl ];


      environment.etc."X11/xorg.conf.d/90-nvidia-screen-G05.conf".source =
        "${pkg}/share/X11/xorg.conf.d/90-nvidia-screen-G05.conf";

      environment.etc."udev/rules.d/90-supergfxd-nvidia-pm.rules".source =
        "${pkg}/udev/rules.d/90-supergfxd-nvidia-pm.rules";

    };

  }
