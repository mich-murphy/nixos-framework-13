{...}: {
  virtualisation.docker = {
    autoPrune.enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
}
