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



    boot.extraModulePackages = with config.boot.kernelPackages; [
      "kvmfr"
    ];
    boot.initrd.kernelModules = [ "kvmfr" ];

    boot.kernelParams = optionals cfg.shm.enable [
      "kvmfr.static_size_mb=128"
    ];

    services.udev.extraRules = optionals cfg.shm.enable ''
      SUBSYSTEM=="kvmfr", OWNER="moxi", GROUP="$kvm", MODE="$660"
    '';


systemd.tmpfiles.rules = [
  "f /dev/shm/scream 0660 moxi qemu-libvirtd -"
  "f /dev/shm/looking-glass 0660 moxi qemu-libvirtd -"
];

boot.postBootCommands = ''
    DEVS="0000:01:00.0 0000:01:00.1"

    for DEV in $DEVS; do
      echo "vfio-pci" > /sys/bus/pci/devices/$DEV/driver_override
    done
    modprobe -i vfio-pci
 '';
 systemd.user.services.scream-ivshmem = {
  enable = true;
  description = "Scream IVSHMEM";
  serviceConfig = {
    ExecStart = "${pkgs.scream-receivers}/bin/scream-ivshmem-pulse /dev/shm/scream";
    Restart = "always";
  };
  wantedBy = [ "multi-user.target" ];
  requires = [ "pulseaudio.service" ];
};
}