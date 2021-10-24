{ lib, pkgs, config, ...}:
with lib;
{

  systemd.services.mount-win10-disks = {
    path = with pkgs; [mdadm util-linux];

    script = ''
      ${pkgs.util-linux}/bin/losetup -f /home/moxi/windows-vmfs/efi1
      ${pkgs.util-linux}/bin/losetup -f  /home/moxi/windows-vmfs/efi2
      ${pkgs.util-linux}/bin/losetup -a
       mdadm --build --verbose /dev/md0 --chunk=512 --level=linear --raid-devices=3 /dev/loop0 /dev/nvme0n1p2 /dev/loop1

    '';
    wantedBy = [ "multi-user.target" ];
  };
}
