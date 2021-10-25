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
  onBoot = "ignore";
  onShutdown = "shutdown";
  qemuVerbatimConfig = ''
        namespaces = []
        nographics_allow_host_audio = 1
        user = "moxi"
        group = "kvm"
      '';
};

 	  boot.extraModprobeConfig = with boot.extraModprobeConfig;  ''
    options kvm ignore_msrs=1
  '';

# systemd.tmpfiles.rules = [
#   "f /dev/shm/looking-glass 0660 moxi qemu-libvirtd -"
# ];

boot.postBootCommands = ''
    DEVS="0000:01:00.0 0000:01:00.1"

    for DEV in $DEVS; do
      echo "vfio-pci" > /sys/bus/pci/devices/$DEV/driver_override
    done
    modprobe -i vfio-pci
    touch /dev/shm/looking-glass
    chown moxi:kvm /dev/shm/looking-glass
    chmod 660 /dev/shm/looking-glass
 '';
}