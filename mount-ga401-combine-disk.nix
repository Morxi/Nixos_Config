{config , ...} :
{
  systemd.services.mount-win10-disks = {
  script = ''
 losetup -f /home/moxi/windows-vmfs/efi1
 losetup -f  /home/moxi/windows-vmfs/efi2
 losetup -a
  mdadm --build --verbose /dev/md0 --chunk=512 --level=linear --raid-devices=3 /dev/loop0 /dev/nvme0n1p2 /dev/loop1

  '';
  wantedBy = [ "multi-user.target" ];
};
}