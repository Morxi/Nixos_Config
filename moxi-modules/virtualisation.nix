{ config, lib, pkgs, ... }:
with lib;
{
 	

environment.systemPackages = with pkgs; [
  virtmanager
  looking-glass-client
];

virtualisation.libvirtd = {
  enable = true;
  qemuOvmf = true;
  qemuRunAsRoot = false;
  onBoot = "ignore";
  onShutdown = "shutdown";
};

 	

systemd.tmpfiles.rules = [
  "f /dev/shm/looking-glass 0660 alex qemu-libvirtd -"
];

boot.postBootCommands = ''
    DEVS="0000:01:00.0 0000:01:00.1"

    for DEV in $DEVS; do
      echo "vfio-pci" > /sys/bus/pci/devices/$DEV/driver_override
    done
    modprobe -i vfio-pci
 '';
}