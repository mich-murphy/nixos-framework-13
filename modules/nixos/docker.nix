{lib, ...}: {
  virtualisation.docker = {
    autoPrune.enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  # The upstream rootless module installs docker.service into every user's
  # systemd instance via `WantedBy=default.target`. System users like `greeter`
  # (greetd) then start it at login, fail because they have no /etc/subuid
  # range, and burn through the StartLimitBurst before the real user logs in:
  #   dockerd-rootless[..]: [rootlesskit:parent] error: failed to setup UID/GID
  #   map: failed to compute uid/gid map: No subuid ranges found for user 994
  #   ("greeter")
  # Refuse to start the unit for system users; only humans (uid >= 1000) have
  # subuid mappings on this host.
  systemd.user.services.docker.unitConfig.ConditionUser = lib.mkForce [
    "!root"
    "!@system"
  ];
}
