{ config, lib, pkgs, newScope,... }:

with lib;
let

  cfg = config.services.charge-limit;

in

{


  options = {
    services.charge-limit = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = "Enable charge-limit Service.";
      };
      limits = mkOption {
        default = 100;
        type = types.int;
        description = "Set Charge Limit value";
      };
      bat = mkOption
        {
          default = "BAT0";
          type = types.str;
          description = "Set Battery Location";

        };
    };

  };

  config = mkIf cfg.enable {

    systemd.services."charge-limi" = {
      enable = true;
      restartIfChanged = true;
      wantedBy = [ "multi-user.target" ];
      description = "charge-limit";
      path = with pkgs; [ busybox ];

      serviceConfig =
        {
          ExecStart = ''${pkgs.busybox}/bin/echo ${toString cfg.limits} > /sys/class/power_supply/${cfg.bat}/charge_control_end_threshold'';
        };

    };


  };

}
