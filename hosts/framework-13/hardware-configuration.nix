# Placeholder — regenerate at install time with:
#   sudo nixos-generate-config --no-filesystems --root /mnt
#   cp /mnt/etc/nixos/hardware-configuration.nix hosts/framework-13/
{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "thunderbolt" "usb_storage" "sd_mod"];
  boot.kernelModules = ["kvm-amd"];

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
