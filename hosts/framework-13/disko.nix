{
  disko.devices = {
    disk.main = {
      type = "disk";
      device = "/dev/nvme0n1";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "2G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = ["defaults" "umask=0077"];
            };
          };
          luks = {
            size = "100%";
            content = {
              type = "luks";
              name = "cryptroot";
              settings.allowDiscards = true;
              content = {
                type = "btrfs";
                extraArgs = ["-f"];
                subvolumes = {
                  "@" = {
                    mountpoint = "/";
                    mountOptions = ["noatime" "compress=zstd:3" "ssd" "space_cache=v2"];
                  };
                  "@home" = {
                    mountpoint = "/home";
                    mountOptions = ["noatime" "compress=zstd:3" "ssd" "space_cache=v2"];
                  };
                  "@nix" = {
                    mountpoint = "/nix";
                    mountOptions = ["noatime" "compress=zstd:3" "ssd" "space_cache=v2"];
                  };
                  "@log" = {
                    mountpoint = "/var/log";
                    mountOptions = ["noatime" "compress=zstd:3" "ssd" "space_cache=v2"];
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
