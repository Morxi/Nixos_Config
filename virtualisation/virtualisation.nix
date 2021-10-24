{ config, lib, pkgs, ... }:
with lib;
{
  virtualisation = {
    libvirtd = {
      enable = true;
      qemuOvmf = true;
      qemuRunAsRoot = false;

      onBoot = "ignore";
      onShutdown = "shutdown";
    };
    vfio = {
      enable = true;
      IOMMUType = "amd";
      devices = [ "10de:2520" "10de:228e" ];
      blacklistNvidia = true;
      disableEFIfb = false;
      ignoreMSRs = true;
      applyACSpatch = false;
    };
    hugepages = {
      enable = true;
      defaultPageSize = "1G";
      pageSize = "1G";
      numPages = 16;
    };
  };


# boot.postBootCommands = ''
#     DEVS="0000:01:00.0 0000:01:00.1"

#     for DEV in $DEVS; do
#       echo "vfio-pci" > /sys/bus/pci/devices/$DEV/driver_override
#     done
#     modprobe -i vfio-pci
#  '';
}